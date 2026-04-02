import { getMessage } from '@/api/messages';
import { navigateToNotificationTarget } from '@/utils/notificationTargetNavigator';

interface OpenPermalinkTargetParams {
  chatId: string;
  messageId: string;
  isDesktop: boolean;
  preserveCurrentEntry?: boolean;
}

export async function openPermalinkTarget({
  chatId,
  messageId,
  isDesktop,
  preserveCurrentEntry = false,
}: OpenPermalinkTargetParams): Promise<void> {
  console.debug('[permalink] resolving target', { chatId, messageId, isDesktop, preserveCurrentEntry });

  const res = await getMessage(chatId, messageId);
  const msg = res.data;
  const threadRootId = msg.replyRootId;
  const target = threadRootId
    ? `/chats/chat/${encodeURIComponent(chatId)}/thread/${threadRootId}`
    : `/chats/chat/${encodeURIComponent(chatId)}`;

  const resumeToken = `${messageId}:${Date.now()}:${Math.random().toString(36).slice(2)}`;
  const state = {
    resumeRequest: { messageId, token: resumeToken },
  };

  console.debug('[permalink] navigating to resolved target', {
    chatId,
    messageId,
    threadRootId,
    target,
    preserveCurrentEntry,
  });

  navigateToNotificationTarget(target, isDesktop, state, { preserveCurrentEntry });
}
