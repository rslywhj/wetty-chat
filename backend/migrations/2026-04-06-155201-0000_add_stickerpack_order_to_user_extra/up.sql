ALTER TABLE user_extra ADD COLUMN sticker_pack_order JSONB NOT NULL DEFAULT '[]'::jsonb;
