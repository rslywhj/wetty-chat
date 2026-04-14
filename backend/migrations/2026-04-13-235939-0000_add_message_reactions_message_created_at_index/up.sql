CREATE INDEX idx_message_reactions_msg_created_at
    ON message_reactions (message_id, created_at);
