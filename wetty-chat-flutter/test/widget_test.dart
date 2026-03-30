import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:wetty_chat_flutter/app/app.dart';

void main() {
  testWidgets('WettyChatApp builds a Cupertino app shell', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const WettyChatApp(
        home: CupertinoPageScaffold(child: Center(child: Text('Smoke Test'))),
      ),
    );

    expect(find.byType(CupertinoApp), findsOneWidget);
    expect(find.text('Smoke Test'), findsOneWidget);
  });
}
