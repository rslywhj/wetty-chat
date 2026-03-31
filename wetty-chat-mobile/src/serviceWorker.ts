/// <reference lib="webworker" />
import { cleanupOutdatedCaches, createHandlerBoundToURL, precacheAndRoute } from 'workbox-precaching';
import { NavigationRoute, registerRoute } from 'workbox-routing';
import { getHighWaterMark, setHighWaterMark } from './utils/db';

declare let self: ServiceWorkerGlobalScope;

async function updateHighWaterMarkIdb(chatId: string, messageId: string): Promise<void> {
  try {
    const id = BigInt(messageId);
    const current = await getHighWaterMark(chatId);
    if (current == null || id > BigInt(current)) {
      await setHighWaterMark(chatId, messageId);
    }
  } catch {
    /* non-numeric id, ignore */
  }
}

async function isAlreadyNotified(chatId: string, messageId: string): Promise<boolean> {
  try {
    const id = BigInt(messageId);
    const mark = await getHighWaterMark(chatId);
    return mark != null && id <= BigInt(mark);
  } catch {
    return false;
  }
}

self.addEventListener('message', (event) => {
  if (event.data && event.data.type === 'SKIP_WAITING') {
    self.skipWaiting();
  }
  if (event.data && event.data.type === 'NOTIFIED') {
    const { chatId, messageId } = event.data;
    if (chatId && messageId) {
      event.waitUntil(updateHighWaterMarkIdb(String(chatId), String(messageId)));
    }
  }
});

const manifest = self.__WB_MANIFEST;
precacheAndRoute(manifest);

// clean old assets
cleanupOutdatedCaches();

// Catch routing to index.html for SPA
let allowlist: undefined | RegExp[];
if (import.meta.env.DEV) {
  allowlist = [/^\/$/];
}

// Workaround for dev server: only register navigation route if index.html is precached
const hasPrecachedIndex = manifest.some((entry) => (typeof entry === 'string' ? entry : entry.url) === 'index.html');

if (hasPrecachedIndex) {
  registerRoute(
    new NavigationRoute(createHandlerBoundToURL('index.html'), {
      allowlist,
      denylist: [/^\/_api/],
    }),
  );
}

self.addEventListener('push', (event) => {
  if (!event.data) return;

  event.waitUntil(
    (async () => {
      try {
        const payload = event.data!.json();
        const title = payload.title || 'New Message';
        const body = payload.body;

        const chatId = payload.data?.chat_id;
        const messageId = payload.data?.message_id;

        if (chatId && messageId && (await isAlreadyNotified(String(chatId), String(messageId)))) {
          return;
        }

        if (chatId && messageId) {
          await updateHighWaterMarkIdb(String(chatId), String(messageId));
        }

        const tag = messageId ? `msg_${messageId}` : undefined;

        await self.registration.showNotification(title, {
          body: body,
          icon: '/icon/pwa-192x192.png',
          badge: '/icon/pwa-64x64.png',
          tag,
          data: payload,
        });
      } catch (err) {
        console.error('Failed to parse push event payload', err);
      }
    })(),
  );
});

self.addEventListener('notificationclick', (event) => {
  event.notification.close();
  // Attempt to focus the app main window if it is open, else open it
  event.waitUntil(
    self.clients.matchAll({ type: 'window' }).then((clientList) => {
      for (const client of clientList) {
        if (client.url.startsWith(self.registration.scope) && 'focus' in client) {
          return client.focus();
        }
      }
      if (self.clients.openWindow) {
        return self.clients.openWindow(`${import.meta.env.BASE_URL}`);
      }
    }),
  );
});
