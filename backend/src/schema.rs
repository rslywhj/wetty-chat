// @generated automatically by Diesel CLI.

diesel::table! {
    attachments (attachment_id) {
        attachment_id -> Int8,
        message_id -> Int8,
        #[max_length = 20]
        kind -> Varchar,
        external_reference -> Text,
        size -> Int8,
        created_at -> Timestamptz,
        deleted_at -> Nullable<Timestamptz>,
    }
}

diesel::table! {
    groups (gid) {
        gid -> Int8,
        #[max_length = 255]
        name -> Nullable<Varchar>,
        created_at -> Timestamptz,
    }
}

diesel::table! {
    messages (id) {
        id -> Int8,
        message -> Nullable<Text>,
        #[max_length = 20]
        message_type -> Varchar,
        reply_to_id -> Nullable<Int8>,
        reply_root_id -> Nullable<Int8>,
        client_generated_id -> Varchar,
        sender_uid -> Int4,
        gid -> Int8,
        created_at -> Timestamptz,
        updated_at -> Nullable<Timestamptz>,
        deleted_at -> Nullable<Timestamptz>,
        has_attachments -> Bool,
    }
}

diesel::table! {
    users (uid) {
        uid -> Int4,
        #[max_length = 15]
        username -> Varchar,
    }
}

diesel::joinable!(attachments -> messages (message_id));
diesel::joinable!(messages -> groups (gid));
diesel::joinable!(messages -> users (sender_uid));

diesel::allow_tables_to_appear_in_same_query!(attachments, groups, messages, users,);
