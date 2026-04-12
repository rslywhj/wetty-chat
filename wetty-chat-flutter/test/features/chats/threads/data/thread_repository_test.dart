import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:chahua/core/api/models/messages_api_models.dart';
import 'package:chahua/core/api/models/websocket_api_models.dart';
import 'package:chahua/core/network/websocket_service.dart';
import 'package:chahua/core/providers/shared_preferences_provider.dart';
import 'package:chahua/features/chats/threads/data/thread_api_service.dart';
import 'package:chahua/features/chats/threads/data/thread_repository.dart';
import 'package:chahua/features/chats/threads/models/thread_api_models.dart';

void main() {
  group('ThreadListNotifier realtime', () {
    test('confirmed thread reply updates preview and reorders row', () async {
      final service = _FakeThreadApiService(
        threadResponses: [
          ListThreadsResponseDto(
            threads: [
              _threadItem(
                rootId: 20,
                chatId: 1,
                rootText: 'root two',
                lastReplyAt: DateTime.parse('2026-01-02T00:00:00Z'),
              ),
              _threadItem(
                rootId: 10,
                chatId: 1,
                rootText: 'root one',
                lastReplyAt: DateTime.parse('2026-01-01T00:00:00Z'),
              ),
            ],
          ),
        ],
      );
      final container = await _containerFor(service);
      addTearDown(container.dispose);

      final notifier = container.read(threadListStateProvider.notifier);
      await notifier.loadThreads();

      notifier.applyRealtimeCreated(
        _message(
          id: 101,
          chatId: 1,
          text: 'latest reply',
          replyRootId: 10,
          createdAt: DateTime.parse('2026-01-03T00:00:00Z'),
        ),
      );

      final state = container.read(threadListStateProvider);
      expect(state.threads.map((t) => t.threadRootId).toList(), [10, 20]);
      expect(state.threads.first.lastReply?.message, 'latest reply');
      expect(state.threads.first.replyCount, 1);
      expect(state.threads.first.unreadCount, 1);
    });

    test('deleted thread root keeps thread row visible', () async {
      final service = _FakeThreadApiService(
        threadResponses: [
          ListThreadsResponseDto(
            threads: [
              _threadItem(
                rootId: 10,
                chatId: 1,
                rootText: 'root one',
                lastReplyAt: DateTime.parse('2026-01-01T00:00:00Z'),
              ),
            ],
          ),
        ],
      );
      final container = await _containerFor(service);
      addTearDown(container.dispose);

      final notifier = container.read(threadListStateProvider.notifier);
      await notifier.loadThreads();

      notifier.applyRealtimeDeleted(
        _message(id: 10, chatId: 1, text: 'root one', isDeleted: true),
      );

      final state = container.read(threadListStateProvider);
      expect(state.threads, hasLength(1));
      expect(state.threads.single.threadRootMessage.isDeleted, isTrue);
    });

    test('deleting current thread preview triggers refresh', () async {
      final service = _FakeThreadApiService(
        threadResponses: [
          ListThreadsResponseDto(
            threads: [
              _threadItem(
                rootId: 10,
                chatId: 1,
                rootText: 'root one',
                lastReply: _replyPreview(id: 100, text: 'reply one'),
                lastReplyAt: DateTime.parse('2026-01-02T00:00:00Z'),
                replyCount: 1,
              ),
            ],
          ),
          ListThreadsResponseDto(
            threads: [
              _threadItem(
                rootId: 10,
                chatId: 1,
                rootText: 'root one',
                lastReplyAt: null,
                replyCount: 0,
              ),
            ],
          ),
        ],
      );
      final container = await _containerFor(service);
      addTearDown(container.dispose);

      final notifier = container.read(threadListStateProvider.notifier);
      await notifier.loadThreads();

      notifier.applyRealtimeDeleted(
        _message(
          id: 100,
          chatId: 1,
          text: 'reply one',
          replyRootId: 10,
          isDeleted: true,
        ),
      );
      await Future<void>.delayed(const Duration(milliseconds: 10));

      final state = container.read(threadListStateProvider);
      expect(service.fetchThreadsCalls, 2);
      expect(state.threads.single.replyCount, 0);
      expect(state.threads.single.lastReply, isNull);
    });
  });
}

Future<ProviderContainer> _containerFor(_FakeThreadApiService service) async {
  SharedPreferences.setMockInitialValues({});
  final prefs = await SharedPreferences.getInstance();
  return ProviderContainer(
    overrides: [
      sharedPreferencesProvider.overrideWithValue(prefs),
      threadApiServiceProvider.overrideWithValue(service),
      wsEventsProvider.overrideWith((ref) => const Stream<ApiWsEvent>.empty()),
    ],
  );
}

class _FakeThreadApiService extends ThreadApiService {
  _FakeThreadApiService({required this.threadResponses}) : super(Dio());

  final List<ListThreadsResponseDto> threadResponses;
  int fetchThreadsCalls = 0;

  @override
  Future<ListThreadsResponseDto> fetchThreads({
    int? limit,
    String? before,
  }) async {
    final index = fetchThreadsCalls < threadResponses.length
        ? fetchThreadsCalls
        : threadResponses.length - 1;
    fetchThreadsCalls += 1;
    return threadResponses[index];
  }

  @override
  Future<UnreadThreadCountResponseDto> fetchUnreadThreadCount() async {
    return const UnreadThreadCountResponseDto(unreadThreadCount: 0);
  }
}

ThreadListItemDto _threadItem({
  required int rootId,
  required int chatId,
  required String rootText,
  ThreadReplyPreviewDto? lastReply,
  required DateTime? lastReplyAt,
  int replyCount = 0,
}) {
  return ThreadListItemDto(
    chatId: chatId,
    chatName: 'chat $chatId',
    threadRootMessage: _message(id: rootId, chatId: chatId, text: rootText),
    lastReply: lastReply,
    replyCount: replyCount,
    lastReplyAt: lastReplyAt,
    subscribedAt: null,
  );
}

ThreadReplyPreviewDto _replyPreview({required int id, required String text}) {
  return ThreadReplyPreviewDto(
    id: id,
    sender: const ThreadParticipantDto(uid: 2, name: 'sender'),
    message: text,
  );
}

MessageItemDto _message({
  required int id,
  required int chatId,
  required String text,
  DateTime? createdAt,
  int? replyRootId,
  bool isDeleted = false,
}) {
  return MessageItemDto(
    id: id,
    message: text,
    messageType: 'text',
    sender: const SenderDto(uid: 2, name: 'sender', gender: 0),
    chatId: chatId,
    createdAt: createdAt,
    isEdited: false,
    isDeleted: isDeleted,
    clientGeneratedId: 'cg-$id',
    replyRootId: replyRootId,
    hasAttachments: false,
    attachments: const [],
  );
}
