CREATE TABLE pinned_messages (
    id           BIGINT      NOT NULL PRIMARY KEY,
    chat_id      BIGINT      NOT NULL REFERENCES groups(id),
    message_id   BIGINT      NOT NULL REFERENCES messages(id),
    pinned_by    INTEGER     NOT NULL,
    pinned_at    TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    expires_at   TIMESTAMPTZ NULL,
    UNIQUE (chat_id, message_id)
);

CREATE INDEX idx_pinned_messages_chat ON pinned_messages (chat_id, pinned_at DESC);
