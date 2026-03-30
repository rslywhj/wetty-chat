import { useHistory } from 'react-router-dom';
import styles from './ChatBubble.module.scss';

export function InviteLinkInline({ code, url }: { code: string; url: string }) {
  const history = useHistory();
  return (
    <a
      href={url}
      className={`${styles.messageLink} ${styles.inviteLink}`}
      onClick={(e) => {
        e.preventDefault();
        e.stopPropagation();
        history.push(`/chats/join/${code}`);
      }}
    >
      {url}
    </a>
  );
}
