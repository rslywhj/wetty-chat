import 'package:flutter/cupertino.dart';

import 'theme/style_config.dart';
import '../features/auth/auth.dart';
import '../features/chats/chats.dart';

class WettyChatApp extends StatelessWidget {
  const WettyChatApp({super.key, this.home});

  final Widget? home;

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      theme: appCupertinoTheme,
      home: home ?? const ChatPage(),
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
