import 'package:freezed_annotation/freezed_annotation.dart';

part 'conversation_scope.freezed.dart';

@freezed
abstract class ConversationScope with _$ConversationScope {
  const ConversationScope._();

  const factory ConversationScope.chat({required String chatId}) = ChatScope;

  const factory ConversationScope.thread({
    required String chatId,
    required String threadRootId,
  }) = ThreadScope;

  bool get isThread => this is ThreadScope;

  String? get threadRootId => switch (this) {
    ThreadScope(:final threadRootId) => threadRootId,
    _ => null,
  };

  String get storageKey => switch (this) {
    ChatScope(:final chatId) => chatId,
    ThreadScope(:final chatId, :final threadRootId) =>
      '$chatId::thread::$threadRootId',
    _ => chatId,
  };
}
