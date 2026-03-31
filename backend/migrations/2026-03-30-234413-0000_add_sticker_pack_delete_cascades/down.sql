ALTER TABLE sticker_pack_stickers
    DROP CONSTRAINT sticker_pack_stickers_pack_id_fkey,
    ADD CONSTRAINT sticker_pack_stickers_pack_id_fkey
        FOREIGN KEY (pack_id) REFERENCES sticker_packs(id);

ALTER TABLE user_sticker_pack_subscriptions
    DROP CONSTRAINT user_sticker_pack_subscriptions_pack_id_fkey,
    ADD CONSTRAINT user_sticker_pack_subscriptions_pack_id_fkey
        FOREIGN KEY (pack_id) REFERENCES sticker_packs(id);
