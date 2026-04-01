import styles from './SystemMessage.module.scss';

interface SystemMessageProps {
  senderName?: string | null;
  message: string;
}

export function SystemMessage({ senderName, message }: SystemMessageProps) {
  return (
    <div className={styles.container}>
      <div className={styles.content}>
        {senderName && <span className={styles.sender}>{senderName}</span>}
        {senderName ? ' ' : ''}
        {message}
      </div>
    </div>
  );
}
