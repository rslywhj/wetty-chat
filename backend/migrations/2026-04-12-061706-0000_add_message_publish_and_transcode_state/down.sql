-- This file should undo anything in `up.sql`
DROP INDEX IF EXISTS idx_messages_audio_transcode_pending;
DROP INDEX IF EXISTS idx_messages_visible_top_level_last;

DROP INDEX IF EXISTS idx_messages_thread_reply_stats;
CREATE INDEX idx_messages_thread_reply_stats
    ON messages(reply_root_id, id DESC)
    WHERE deleted_at IS NULL;

DROP INDEX IF EXISTS idx_messages_chat_sender_active;
CREATE INDEX idx_messages_chat_sender_active
    ON messages (chat_id, sender_uid, created_at DESC)
    WHERE deleted_at IS NULL;

DROP INDEX IF EXISTS idx_messages_unread_count;
CREATE INDEX idx_messages_unread_count
    ON messages(chat_id, id DESC)
    WHERE deleted_at IS NULL
      AND reply_root_id IS NULL;

ALTER TABLE messages
    DROP COLUMN transcode_status,
    DROP COLUMN is_published;

DROP TYPE transcode_status;
