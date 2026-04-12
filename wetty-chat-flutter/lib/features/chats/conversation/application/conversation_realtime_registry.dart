import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/api/models/websocket_api_models.dart';

typedef ConversationRealtimeListener = void Function(ApiWsEvent event);

/// Broadcasts routed realtime events to active conversation timelines.
class ConversationRealtimeRegistry {
  final Map<Object, ConversationRealtimeListener> _listeners =
      <Object, ConversationRealtimeListener>{};

  Object addListener(ConversationRealtimeListener listener) {
    final token = Object();
    _listeners[token] = listener;
    return token;
  }

  void removeListener(Object token) {
    _listeners.remove(token);
  }

  void dispatch(ApiWsEvent event) {
    for (final listener in _listeners.values.toList(growable: false)) {
      listener(event);
    }
  }
}

final conversationRealtimeRegistryProvider =
    Provider<ConversationRealtimeRegistry>((ref) {
      return ConversationRealtimeRegistry();
    });
