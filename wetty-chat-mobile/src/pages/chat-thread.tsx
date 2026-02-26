import React, { useRef, useState, useEffect } from 'react';
import {
  f7,
  Icon,
  Navbar,
  Link,
  Page,
  Messages,
  Message,
  Messagebar,
} from 'framework7-react';
import type { Messagebar as F7MessagebarInstance } from 'framework7/types';
import '@/css/chat-thread.scss';
import {
  getMessages,
  sendMessage,
  type MessageResponse,
} from '@/api/messages';
import { getCurrentUserId } from '@/js/current-user';

interface Props {
  f7route?: {
    params: Record<string, string>;
    route?: { context?: { chatName?: string }; options?: { props?: { chatName?: string } } };
  };
}

function generateClientId(): string {
  return `cg_${Date.now()}_${Math.random().toString(36).slice(2)}`;
}

function messageTime(createdAt: string): string {
  return Intl.DateTimeFormat('en', {
    hour: 'numeric',
    minute: 'numeric',
  }).format(new Date(createdAt));
}

function isSent(message: MessageResponse): boolean {
  return message.sender_uid === getCurrentUserId();
}

export default function ChatThread({ f7route }: Props) {
  const { id } = f7route?.params || {};
  const chatId = id ? String(id) : '';
  const chatName =
    f7route?.route?.options?.props?.chatName ??
    f7route?.route?.context?.chatName ??
    (id ? `Chat ${id}` : 'Chat');

  type MessagebarRefValue = { el: HTMLElement | null; f7Messagebar: () => F7MessagebarInstance.Messagebar };
  const messagebarRef = useRef<MessagebarRefValue | null>(null);
  const [messages, setMessages] = useState<MessageResponse[]>([]);
  const [nextCursor, setNextCursor] = useState<string | null>(null);
  const [loading, setLoading] = useState(true);
  const [loadingMore, setLoadingMore] = useState(false);
  const [messageText, setMessageText] = useState('');
  const [error, setError] = useState<string | null>(null);

  // Display order: oldest first (backend returns newest first, so we reverse when storing).
  useEffect(() => {
    if (!chatId) return;
    setLoading(true);
    setError(null);
    getMessages(chatId)
      .then((res) => {
        const list = res.data.messages ?? [];
        setMessages([...list].reverse());
        setNextCursor(res.data.next_cursor ?? null);
      })
      .catch((err: Error) => {
        setError(err.message || 'Failed to load messages');
        setMessages([]);
        setNextCursor(null);
        f7.toast.create({ text: err.message || 'Failed to load messages', closeTimeout: 3000 }).open();
      })
      .finally(() => setLoading(false));
  }, [chatId]);

  const loadMore = () => {
    if (!chatId || nextCursor == null || loadingMore) return;
    setLoadingMore(true);
    getMessages(chatId, { before: nextCursor, max: 50 })
      .then((res) => {
        const list = res.data.messages ?? [];
        const older = [...list].reverse();
        setMessages((prev) => [...older, ...prev]);
        setNextCursor(res.data.next_cursor ?? null);
      })
      .catch((err: Error) => {
        f7.toast.create({ text: err.message || 'Failed to load more', closeTimeout: 3000 }).open();
      })
      .finally(() => setLoadingMore(false));
  };

  const handleSend = () => {
    const text = messageText.trim();
    if (!text || !chatId) return;
    const clientGeneratedId = generateClientId();
    setMessageText('');
    const optimistic: MessageResponse = {
      id: '0',
      message: text,
      message_type: 'text',
      reply_to_id: null,
      reply_root_id: null,
      client_generated_id: clientGeneratedId,
      sender_uid: getCurrentUserId(),
      gid: chatId,
      created_at: new Date().toISOString(),
      updated_at: null,
      deleted_at: null,
      has_attachments: false,
    };
    setMessages((prev) => [...prev, optimistic]);
    sendMessage(chatId, {
      message: text,
      message_type: 'text',
      client_generated_id: clientGeneratedId,
    })
      .then((res) => {
        const created = res.data;
        setMessages((prev) =>
          prev.map((m) =>
            m.client_generated_id === clientGeneratedId ? created : m
          )
        );
      })
      .catch((err: Error) => {
        f7.toast.create({ text: err.message || 'Failed to send', closeTimeout: 3000 }).open();
        setMessages((prev) => prev.filter((m) => m.client_generated_id !== clientGeneratedId));
        setMessageText(text);
      });
    setTimeout(() => {
      const mb = messagebarRef.current?.f7Messagebar?.();
      if (typeof mb?.focus === 'function') mb.focus();
    }, 0);
  };

  // Move focus into this page so the previous page's link isn't focused when aria-hidden is applied.
  const moveFocusToThisPage = () => {
    const mb = messagebarRef.current?.f7Messagebar?.();
    if (typeof mb?.focus === 'function') {
      mb.focus();
    } else {
      const pageEl = document.querySelector('.chat-thread-page.page-current, .chat-thread-page.page-next');
      if (pageEl instanceof HTMLElement) {
        if (!pageEl.hasAttribute('tabindex')) pageEl.setAttribute('tabindex', '-1');
        pageEl.focus({ preventScroll: true });
      }
    }
  };
  const handlePageBeforeIn = () => requestAnimationFrame(moveFocusToThisPage);
  const handlePageAfterIn = () => moveFocusToThisPage();

  const displayMessages = messages;
  const isMessageFirst = (index: number): boolean => {
    if (index <= 0) return true;
    return isSent(displayMessages[index]) !== isSent(displayMessages[index - 1]);
  };
  const isMessageLast = (index: number): boolean => {
    if (index >= displayMessages.length - 1) return true;
    return isSent(displayMessages[index]) !== isSent(displayMessages[index + 1]);
  };

  return (
    <Page
      className="messages-page chat-thread-page"
      noToolbar
      messagesContent
      onPageBeforeIn={handlePageBeforeIn}
      onPageAfterIn={handlePageAfterIn}
    >
      <Navbar className="messages-navbar" title={chatName} backLink backLinkShowText={false} />
      <Messagebar
        ref={messagebarRef as React.RefObject<MessagebarRefValue>}
        placeholder="Message"
        value={messageText}
        onInput={(e) => setMessageText((e.target as HTMLInputElement)?.value ?? '')}
        onSubmit={handleSend}
      >
        <button
          type="button"
          slot="send-link"
          className={`messagebar-send-link ${messageText.trim().length === 0 ? 'messagebar-send-link--disabled' : ''}`}
          onClick={(e) => {
            e.stopPropagation();
            handleSend();
          }}
          aria-label="Send message"
        >
          <Icon f7="paperplane_fill" />
        </button>
      </Messagebar>
      <Messages>
        {loading ? (
          <div className="chat-thread-loading">Loading…</div>
        ) : error ? (
          <div className="chat-thread-error">{error}</div>
        ) : (
          <>
            {nextCursor != null && (
              <div className="chat-thread-load-more">
                <Link
                  className={loadingMore ? 'link-disabled' : undefined}
                  onClick={() => !loadingMore && loadMore()}
                >
                  {loadingMore ? 'Loading…' : 'Load older messages'}
                </Link>
              </div>
            )}
            {displayMessages.map((message, index) => (
              <Message
                key={message.id || message.client_generated_id}
                type={isSent(message) ? 'sent' : 'received'}
                first={isMessageFirst(index)}
                last={isMessageLast(index)}
                tail={isMessageLast(index)}
                text={message.deleted_at ? '[Deleted]' : (message.message ?? '')}
                className="message-appear-from-bottom"
              >
                <span slot="text-footer">{messageTime(message.created_at)}</span>
              </Message>
            ))}
          </>
        )}
      </Messages>
    </Page>
  );
}
