import 'package:flutter_test/flutter_test.dart';

import 'package:wetty_chat_flutter/features/chats/list/data/chat_api_service.dart';
import 'package:wetty_chat_flutter/features/chats/list/data/chat_repository.dart';
import 'package:wetty_chat_flutter/features/chats/models/chat_models.dart';

void main() {
  group('ChatRepository realtime', () {
    test('message event updates loaded chat and moves it to the top', () async {
      final repository = ChatRepository(service: _FakeChatApiService([
        ListChatsResponse(
          chats: [
            ChatListItem(id: '1', name: 'one'),
            ChatListItem(id: '2', name: 'two'),
          ],
        ),
      ]));

      await repository.loadChats();
      repository.applyRealtimeEvent(_messageEvent(chatId: '2', messageId: 200));

      expect(repository.chats.map((chat) => chat.id).toList(), ['2', '1']);
      expect(repository.chats.first.lastMessage?.id, 200);
      expect(repository.chats.first.unreadCount, 1);
    });

    test('message event refreshes when chat is not in the loaded page', () async {
      final service = _FakeChatApiService([
        ListChatsResponse(
          chats: [
            ChatListItem(id: '1', name: 'one'),
          ],
        ),
        ListChatsResponse(
          chats: [
            ChatListItem(id: '2', name: 'two'),
            ChatListItem(id: '1', name: 'one'),
          ],
        ),
      ]);
      final repository = ChatRepository(service: service);

      await repository.loadChats();
      repository.applyRealtimeEvent(_messageEvent(chatId: '2', messageId: 200));
      await Future<void>.delayed(Duration.zero);
      await Future<void>.delayed(Duration.zero);

      expect(service.fetchChatsCalls, 2);
      expect(repository.chats.map((chat) => chat.id).toList(), ['2', '1']);
    });
  });
}

class _FakeChatApiService extends ChatApiService {
  _FakeChatApiService(this._responses);

  final List<ListChatsResponse> _responses;
  int fetchChatsCalls = 0;

  @override
  Future<ListChatsResponse> fetchChats({int? limit, String? after}) async {
    final index = fetchChatsCalls < _responses.length
        ? fetchChatsCalls
        : _responses.length - 1;
    fetchChatsCalls++;
    return _responses[index];
  }
}

Map<String, dynamic> _messageEvent({
  required String chatId,
  required int messageId,
}) {
  return {
    'type': 'message',
    'payload': {
      'id': messageId.toString(),
      'message': 'hello',
      'message_type': 'text',
      'sender': {
        'uid': 999,
        'name': 'sender',
        'gender': 0,
      },
      'chat_id': chatId,
      'created_at': '2026-01-01T00:00:00Z',
      'is_edited': false,
      'is_deleted': false,
      'client_generated_id': 'cg-$messageId',
      'has_attachments': false,
      'attachments': const [],
    },
  };
}
