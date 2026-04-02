import { useHistory } from 'react-router-dom';
import styles from './ChatBubble.module.scss';
import { useChatContext } from './ChatContext';

interface PermalinkInlineProps {
  targetChatId: string;
  targetMessageId: string;
  encoded: string;
  url: string;
}

export function PermalinkInline({ targetChatId, targetMessageId, encoded, url }: PermalinkInlineProps) {
  const history = useHistory();
  const ctx = useChatContext();

  return (
    <a
      href={url}
      className={styles.messageLink}
      onClick={(e) => {
        e.preventDefault();
        e.stopPropagation();

        if (ctx && ctx.chatId === targetChatId) {
          // Same chat/thread — scroll to message in place
          ctx.jumpToMessage(targetMessageId);
        } else {
          // Different chat — navigate through permalink resolver
          history.push(`/m/${encoded}`);
        }
      }}
    >
      {url}
    </a>
  );
}
