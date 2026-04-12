-- Your SQL goes here
CREATE TYPE transcode_status AS ENUM ('none', 'pending', 'done', 'failed');

ALTER TABLE messages
    ADD COLUMN is_published BOOLEAN NOT NULL DEFAULT true,
    ADD COLUMN transcode_status transcode_status NOT NULL DEFAULT 'none';

DROP INDEX IF EXISTS idx_messages_unread_count;
CREATE INDEX idx_messages_unread_count
    ON messages(chat_id, id DESC)
    WHERE deleted_at IS NULL
      AND is_published = true
      AND reply_root_id IS NULL;

DROP INDEX IF EXISTS idx_messages_chat_sender_active;
CREATE INDEX idx_messages_chat_sender_active
    ON messages (chat_id, sender_uid, created_at DESC)
    WHERE deleted_at IS NULL
      AND is_published = true;

DROP INDEX IF EXISTS idx_messages_thread_reply_stats;
CREATE INDEX idx_messages_thread_reply_stats
    ON messages(reply_root_id, id DESC)
    WHERE deleted_at IS NULL
      AND is_published = true;

CREATE INDEX idx_messages_visible_top_level_last
    ON messages(chat_id, id DESC)
    WHERE deleted_at IS NULL
      AND is_published = true
      AND reply_root_id IS NULL;

CREATE INDEX idx_messages_audio_transcode_pending
    ON messages(id)
    WHERE message_type = 'audio'
      AND transcode_status = 'pending';
