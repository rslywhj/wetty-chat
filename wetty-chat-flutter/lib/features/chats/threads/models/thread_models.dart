import 'package:freezed_annotation/freezed_annotation.dart';

import '../../models/message_models.dart';

part 'thread_models.freezed.dart';

@freezed
abstract class ThreadParticipant with _$ThreadParticipant {
  const factory ThreadParticipant({
    required int uid,
    String? name,
    String? avatarUrl,
  }) = _ThreadParticipant;
}

@freezed
abstract class ThreadReplyPreview with _$ThreadReplyPreview {
  const factory ThreadReplyPreview({
    int? messageId,
    String? clientGeneratedId,
    required ThreadParticipant sender,
    String? message,
    @Default('text') String messageType,
    String? stickerEmoji,
    String? firstAttachmentKind,
    @Default(false) bool isDeleted,
    @Default([]) List<MentionInfo> mentions,
  }) = _ThreadReplyPreview;
}

@freezed
abstract class ThreadListItem with _$ThreadListItem {
  const ThreadListItem._();

  const factory ThreadListItem({
    required String chatId,
    required String chatName,
    String? chatAvatar,
    required MessageItem threadRootMessage,
    @Default([]) List<ThreadParticipant> participants,
    ThreadReplyPreview? lastReply,
    @Default(0) int replyCount,
    DateTime? lastReplyAt,
    @Default(0) int unreadCount,
    DateTime? subscribedAt,
  }) = _ThreadListItem;

  /// Thread root message ID used as the unique key for this thread.
  int get threadRootId => threadRootMessage.id;
}
