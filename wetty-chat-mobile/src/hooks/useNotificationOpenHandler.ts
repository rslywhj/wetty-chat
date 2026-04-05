import { useEffect } from 'react';
import { resolveNotificationTarget, type NotificationOpenMessage } from '@/utils/notificationNavigation';
import { navigateToNotificationTarget } from '@/utils/notificationTargetNavigator';

function isNotificationOpenMessage(data: unknown): data is NotificationOpenMessage {
  return (
    typeof data === 'object' &&
    data !== null &&
    'type' in data &&
    (data as { type?: unknown }).type === 'OPEN_NOTIFICATION_TARGET'
  );
}

export function useNotificationOpenHandler(): void {
  useEffect(() => {
    if (!('serviceWorker' in navigator)) {
      return;
    }

    const handleMessage = (event: MessageEvent<unknown>) => {
      console.debug('[app] service worker message received', {
        data: event.data,
        pathname: window.location.pathname,
        visibilityState: document.visibilityState,
        hasFocus: typeof document.hasFocus === 'function' ? document.hasFocus() : null,
      });

      if (!isNotificationOpenMessage(event.data)) {
        return;
      }

      const target = resolveNotificationTarget({
        chatId: event.data.chatId,
        threadRootId: event.data.threadRootId,
        target: event.data.target,
      });

      console.debug('[app] resolved notification target', { target });
      navigateToNotificationTarget(target);
    };

    navigator.serviceWorker.addEventListener('message', handleMessage);

    return () => {
      navigator.serviceWorker.removeEventListener('message', handleMessage);
    };
  }, []);
}
