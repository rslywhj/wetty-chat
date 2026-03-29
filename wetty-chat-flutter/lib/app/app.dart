import 'package:flutter/cupertino.dart';

import '../features/auth/presentation/token_import_page.dart';
import '../features/chats/list/presentation/chat_list_view.dart';
import '../features/auth/application/auth_store.dart';

class WettyChatApp extends StatelessWidget {
  const WettyChatApp({super.key, this.home});

  final Widget? home;

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      // TODO: implement auth later
      home: const ChatPage(),
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: AuthStore.instance,
      builder: (context, _) {
        if (AuthStore.instance.hasToken) {
          return const ChatPage();
        }
        return const TokenImportPage();
      },
    );
  }
}
