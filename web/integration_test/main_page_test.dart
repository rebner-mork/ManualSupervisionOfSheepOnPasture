import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:web/main/main_page.dart';

import 'firebaseSetup.dart';

void main() async {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  await firebaseSetup();

  testWidgets('Initial layout and content', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: MainPage()));

    expect(find.text('Årsrapporter'), findsOneWidget);
    expect(find.text('Oppsynsturer'), findsOneWidget);
    expect(find.text('Min side'), findsOneWidget);
  });
}
