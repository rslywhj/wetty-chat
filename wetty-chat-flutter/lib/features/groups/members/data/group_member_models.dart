import 'package:freezed_annotation/freezed_annotation.dart';

part 'group_member_models.freezed.dart';

@freezed
abstract class GroupMember with _$GroupMember {
  const factory GroupMember({
    required int uid,
    String? username,
    String? avatarUrl,
    required String role,
    DateTime? joinedAt,
  }) = _GroupMember;
}

enum GroupMemberSearchMode { autocomplete, submitted }

extension GroupMemberSearchModeWireValue on GroupMemberSearchMode {
  String get wireValue => switch (this) {
    GroupMemberSearchMode.autocomplete => 'autocomplete',
    GroupMemberSearchMode.submitted => 'submitted',
  };
}

@freezed
abstract class GroupMembersPage with _$GroupMembersPage {
  const factory GroupMembersPage({
    required List<GroupMember> members,
    @Default(false) bool canManageMembers,
    int? nextCursor,
  }) = _GroupMembersPage;
}
