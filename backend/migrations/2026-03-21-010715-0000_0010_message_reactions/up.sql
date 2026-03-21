-- Add denormalized flag to messages (matches has_attachments, has_thread pattern)
ALTER TABLE messages ADD COLUMN has_reactions BOOLEAN NOT NULL DEFAULT FALSE;

-- Individual reaction rows: one per (message, user, emoji)
CREATE TABLE message_reactions (
    message_id BIGINT NOT NULL REFERENCES messages(id),
    user_uid   INTEGER NOT NULL,
    emoji      VARCHAR(32) NOT NULL CHECK (emoji <> ''),
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    PRIMARY KEY (message_id, user_uid, emoji)
);

-- Batch-load reaction summaries: GROUP BY (message_id, emoji) for count aggregation
-- PK has user_uid in the middle, making it suboptimal for this grouping
CREATE INDEX idx_message_reactions_msg_emoji
    ON message_reactions (message_id, emoji);

-- "Which emojis did I react with?" for current user highlight state
-- Covers: WHERE message_id = ANY($1) AND user_uid = $2
CREATE INDEX idx_message_reactions_msg_user
    ON message_reactions (message_id, user_uid);
