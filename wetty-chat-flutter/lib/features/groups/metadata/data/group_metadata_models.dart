import 'package:freezed_annotation/freezed_annotation.dart';

part 'group_metadata_models.freezed.dart';

@freezed
abstract class ChatMetadata with _$ChatMetadata {
  const ChatMetadata._();

  const factory ChatMetadata({
    required String id,
    required String name,
    String? description,
    String? avatarUrl,
    String? avatarImageId,
    @Default('public') String visibility,
    DateTime? createdAt,
    DateTime? mutedUntil,
    String? myRole,
  }) = _ChatMetadata;

  String get displayName {
    final trimmed = name.trim();
    return trimmed.isEmpty ? 'Chat $id' : trimmed;
  }
}
