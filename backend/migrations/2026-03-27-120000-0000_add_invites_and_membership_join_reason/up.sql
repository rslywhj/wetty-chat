CREATE TYPE invite_type AS ENUM ('generic', 'targeted', 'membership');
CREATE TYPE group_join_reason AS ENUM ('other', 'creator', 'invite_code', 'direct_invite');

CREATE TABLE invites (
    id BIGINT PRIMARY KEY,
    code VARCHAR(12) NOT NULL UNIQUE,
    chat_id BIGINT NOT NULL REFERENCES groups(id),
    invite_type invite_type NOT NULL,
    creator_uid INTEGER DEFAULT NULL,
    target_uid INTEGER DEFAULT NULL,
    required_chat_id BIGINT DEFAULT NULL REFERENCES groups(id),
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    expires_at TIMESTAMPTZ DEFAULT NULL,
    revoked_at TIMESTAMPTZ DEFAULT NULL,
    used_at TIMESTAMPTZ DEFAULT NULL,
    CONSTRAINT invites_code_length_chk CHECK (char_length(code) BETWEEN 8 AND 12),
    CONSTRAINT invites_targeting_chk CHECK (
        (invite_type = 'generic' AND target_uid IS NULL AND required_chat_id IS NULL)
        OR (invite_type = 'targeted' AND target_uid IS NOT NULL AND required_chat_id IS NULL)
        OR (invite_type = 'membership' AND target_uid IS NULL AND required_chat_id IS NOT NULL)
    )
);

CREATE INDEX idx_invites_chat_created_at ON invites(chat_id, created_at DESC);
CREATE INDEX idx_invites_creator_created_at ON invites(creator_uid, created_at DESC)
    WHERE creator_uid IS NOT NULL;

ALTER TABLE group_membership
    ADD COLUMN join_reason group_join_reason NOT NULL DEFAULT 'other',
    ADD COLUMN join_reason_extra JSONB DEFAULT NULL;
