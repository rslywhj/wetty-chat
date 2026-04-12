import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/api/models/websocket_api_models.dart';

typedef ConversationRealtimeListener = void Function(ApiWsEvent event);

/// Broadcasts routed realtime events to active conversation timelines.
class ConversationRealtimeRegistry {
  final Map<Object, ConversationRealtimeListener> _listeners =
      <Object, ConversationRealtimeListener>{};
  String? _lastEventKey;

  Object addListener(ConversationRealtimeListener listener) {
    final token = Object();
    _listeners[token] = listener;
    return token;
  }

  void removeListener(Object token) {
    _listeners.remove(token);
  }

  void dispatch(ApiWsEvent event) {
    final eventKey = switch (event) {
      MessageCreatedWsEvent(:final payload) => [
        'messageCreated',
        payload.id,
        payload.chatId,
        payload.replyRootId,
        payload.clientGeneratedId,
        payload.createdAt?.millisecondsSinceEpoch,
        payload.isDeleted,
      ].join(':'),
      MessageUpdatedWsEvent(:final payload) => [
        'messageUpdated',
        payload.id,
        payload.chatId,
        payload.replyRootId,
        payload.clientGeneratedId,
        payload.createdAt?.millisecondsSinceEpoch,
        payload.isDeleted,
      ].join(':'),
      MessageDeletedWsEvent(:final payload) => [
        'messageDeleted',
        payload.id,
        payload.chatId,
        payload.replyRootId,
        payload.clientGeneratedId,
        payload.createdAt?.millisecondsSinceEpoch,
        payload.isDeleted,
      ].join(':'),
      ReactionUpdatedWsEvent(:final payload) => [
        'reactionUpdated',
        payload.chatId,
        payload.messageId,
        payload.reactions
            .map((reaction) => '${reaction.emoji}:${reaction.count}')
            .join(','),
      ].join(':'),
      ThreadUpdatedWsEvent(:final payload) => [
        'threadUpdated',
        payload.chatId,
        payload.threadRootId,
        payload.lastReplyAt.millisecondsSinceEpoch,
        payload.replyCount,
      ].join(':'),
      StickerPackOrderUpdatedWsEvent(:final payload) => [
        'stickerPackOrderUpdated',
        payload.order
            .map((item) => '${item.stickerPackId}:${item.lastUsedOn}')
            .join(','),
      ].join(':'),
      PongWsEvent() => 'pong',
    };
    if (_lastEventKey == eventKey) {
      return;
    }
    _lastEventKey = eventKey;
    for (final listener in _listeners.values.toList(growable: false)) {
      listener(event);
    }
  }
}

final conversationRealtimeRegistryProvider =
    Provider<ConversationRealtimeRegistry>((ref) {
      return ConversationRealtimeRegistry();
    });
