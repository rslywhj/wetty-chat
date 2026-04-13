import 'package:flutter_test/flutter_test.dart';

import 'package:chahua/core/api/models/chats_api_models.dart';
import 'package:chahua/features/chats/models/chat_api_mapper.dart';

void main() {
  test('maps chat avatar from DTO to domain model', () {
    const dto = ChatListItemDto(
      id: 42,
      name: 'General',
      avatar: 'https://example.com/group.png',
    );

    final chat = dto.toDomain();

    expect(chat.id, '42');
    expect(chat.name, 'General');
    expect(chat.avatarUrl, 'https://example.com/group.png');
  });
}
