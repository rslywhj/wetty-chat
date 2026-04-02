import { appHistory } from '@/utils/navigationHistory';

const DEFAULT_NOTIFICATION_TARGET = '/chats';
const THREAD_TARGET_RE = /^\/chats\/chat\/([^/]+)\/thread\/([^/]+)$/;

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

function pushHiddenHistoryEntry(pathname: string) {
  const href = appHistory.createHref({ pathname });
  const key = Math.random().toString(36).slice(2, 8);
  window.history.pushState({ key, state: undefined }, '', href);
}

export function navigateToNotificationTarget(
  target: string,
  isDesktop: boolean,
  state?: object,
  options?: NavigateToNotificationTargetOptions,
): void {
  clearPendingMobileNavigation();
  const currentPath = appHistory.location.pathname;
  const preserveCurrentEntry = options?.preserveCurrentEntry ?? false;

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

  if (isDesktop) {
    console.debug(preserveCurrentEntry ? '[app] pushing desktop route' : '[app] replacing desktop route', { target });
    if (preserveCurrentEntry) {
      appHistory.push({ pathname: target, state });
    } else {
      appHistory.replace({ pathname: target, state });
    }
    return;
  }

  if (preserveCurrentEntry) {
    const threadMatch = THREAD_TARGET_RE.exec(target);
    console.debug('[app] seeding mobile back stack for direct target', { target, threadMatch });
    pushHiddenHistoryEntry(DEFAULT_NOTIFICATION_TARGET);
    if (threadMatch) {
      const chatPath = `/chats/chat/${threadMatch[1]}`;
      pushHiddenHistoryEntry(chatPath);
    }
    appHistory.push({ pathname: target, state });
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
        console.debug('[app] pushing mobile notification target after root replace', {
          currentPath: appHistory.location.pathname,
          target,
        });
        appHistory.push({ pathname: target, state });
      }
    }, 0),
  );
}
