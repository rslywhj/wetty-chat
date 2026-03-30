import 'message_models.dart';

sealed class InputState {}

enum ChatWindowMode { latest, aroundMessage, unreadBoundary }

class InputEmpty extends InputState {}

class InputReplying extends InputState {
  InputReplying(this.message);

  final MessageItem message;
}

class InputEditing extends InputState {
  InputEditing(this.message);

  final MessageItem message;
}
