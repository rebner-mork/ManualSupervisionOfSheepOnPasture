import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:web/main_page/main_page.dart';

import 'firebase_setup.dart';

void main() async {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  await firebaseSetup(createUser: true, signIn: true);

  testWidgets('Initial layout and content', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: MainPage()));

    expect(find.text('Årsrapporter'), findsOneWidget);
    expect(find.text('Oppsynsturer'), findsOneWidget);
    expect(find.text('Min side'), findsOneWidget);
  });
}
