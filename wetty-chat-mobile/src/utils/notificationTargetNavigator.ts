import { appHistory } from '@/utils/navigationHistory';

const DEFAULT_NOTIFICATION_TARGET = '/chats';
const THREAD_TARGET_RE = /^\/chats\/chat\/([^/]+)\/thread\/([^/]+)$/;
const DESKTOP_QUERY = '(min-width: 900px)';

let pendingMobileNavigationIds: number[] = [];

interface NavigateToNotificationTargetOptions {
  preserveCurrentEntry?: boolean;
}

function clearPendingMobileNavigation() {
  for (const id of pendingMobileNavigationIds) {
    window.clearTimeout(id);
  }
  pendingMobileNavigationIds = [];
}

/** Read current layout at execution time — not from a stale React hook value. */
function isDesktopLayout(): boolean {
  return window.matchMedia(DESKTOP_QUERY).matches;
}

export function navigateToNotificationTarget(
  target: string,
  state?: object,
  options?: NavigateToNotificationTargetOptions,
): void {
  clearPendingMobileNavigation();
  const currentPath = appHistory.location.pathname;
  const preserveCurrentEntry = options?.preserveCurrentEntry ?? false;
  const isDesktop = isDesktopLayout();

  console.debug('[app] navigateToNotificationTarget', {
    target,
    isDesktop,
    currentPath,
    historyLength: window.history.length,
    preserveCurrentEntry,
  });

  if (currentPath === target) {
    console.debug('[app] notification target already active');
    return;
  }

  // When preserving the current entry (e.g. user clicked a link in a message),
  // always push — the back button returns to where they were.  No back-stack
  // seeding needed because there is a real page behind us.
  if (preserveCurrentEntry) {
    console.debug('[app] pushing route (preserveCurrentEntry)', { target });
    appHistory.push({ pathname: target, state });
    return;
  }

  // --- Non-preserving paths (cold-start: notifications, push-open, permalink page) ---

  if (isDesktop) {
    console.debug('[app] replacing desktop route', { target });
    appHistory.replace({ pathname: target, state });
    return;
  }

  if (target === DEFAULT_NOTIFICATION_TARGET) {
    console.debug('[app] replacing mobile route with chats root');
    appHistory.replace(DEFAULT_NOTIFICATION_TARGET);
    return;
  }

  // For thread targets, build a 3-level back stack: /chats → /chats/chat/:id → /chats/chat/:id/thread/:threadId
  const threadMatch = THREAD_TARGET_RE.exec(target);
  if (threadMatch) {
    const chatPath = `/chats/chat/${threadMatch[1]}`;
    console.debug('[app] rebuilding mobile stack for thread notification target', { target, chatPath });
    appHistory.replace(DEFAULT_NOTIFICATION_TARGET);
    pendingMobileNavigationIds.push(
      window.setTimeout(() => {
        appHistory.push(chatPath);
        pendingMobileNavigationIds.push(
          window.setTimeout(() => {
            if (appHistory.location.pathname !== target) {
              appHistory.push({ pathname: target, state });
            }
          }, 0),
        );
      }, 0),
    );
    return;
  }

  console.debug('[app] rebuilding mobile stack for notification target', { target });
  appHistory.replace(DEFAULT_NOTIFICATION_TARGET);
  pendingMobileNavigationIds.push(
    window.setTimeout(() => {
      if (appHistory.location.pathname !== target) {
        appHistory.push({ pathname: target, state });
      }
    }, 0),
  );
}
