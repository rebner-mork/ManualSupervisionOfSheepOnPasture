import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:web/main_tabs/main_tabs.dart';

import 'firebase_setup.dart';

void main() async {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  await firebaseSetup(createUser: true, signIn: true);

  testWidgets('Initial layout and content', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: MainTabs()));

    expect(find.text('Årsrapporter'), findsOneWidget);
    expect(find.text('Oppsynsturer'), findsOneWidget);
    expect(find.text('Min side'), findsOneWidget);
  });
}
