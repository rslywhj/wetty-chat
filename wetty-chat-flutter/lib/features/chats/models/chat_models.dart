import 'package:freezed_annotation/freezed_annotation.dart';

import 'message_models.dart';

part 'chat_models.freezed.dart';

@freezed
abstract class ChatListItem with _$ChatListItem {
  const factory ChatListItem({
    required String id,
    String? name,
    DateTime? lastMessageAt,
    @Default(0) int unreadCount,
    String? lastReadMessageId,
    MessageItem? lastMessage,
    DateTime? mutedUntil,
  }) = _ChatListItem;
}

@freezed
abstract class ListChatsResponse with _$ListChatsResponse {
  const factory ListChatsResponse({
    required List<ChatListItem> chats,
    String? nextCursor,
  }) = _ListChatsResponse;
}
