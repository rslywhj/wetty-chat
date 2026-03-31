export interface ChatThreadResumeRequest {
  messageId: string;
  token: string;
}

export interface ChatThreadRouteState {
  backgroundPath?: string;
  resumeRequest?: ChatThreadResumeRequest;
}

export function buildChatThreadRouteState(params: {
  unreadCount: number;
  lastReadMessageId: string | null | undefined;
}): ChatThreadRouteState | undefined {
  if (params.unreadCount <= 0 || params.lastReadMessageId == null) return undefined;

  return {
    resumeRequest: {
      messageId: params.lastReadMessageId,
      token: `${params.lastReadMessageId}:${Date.now()}:${Math.random().toString(36).slice(2)}`,
    },
  };
}
