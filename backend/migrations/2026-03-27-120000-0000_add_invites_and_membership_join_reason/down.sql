ALTER TABLE group_membership
    DROP COLUMN join_reason_extra,
    DROP COLUMN join_reason;

DROP INDEX IF EXISTS idx_invites_creator_created_at;
DROP INDEX IF EXISTS idx_invites_chat_created_at;
DROP TABLE IF EXISTS invites;

DROP TYPE IF EXISTS group_join_reason;
DROP TYPE IF EXISTS invite_type;
