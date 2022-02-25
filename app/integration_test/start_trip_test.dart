import 'package:app/trip/start_trip_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'firebase_setup.dart';

void main() async {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  await firebaseSetup(createUser: true, signIn: true);
  await setUpFarm();

  group('Start trip tests', () {
    testWidgets('Initial layout', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: StartTripPage()));

      expect(find.text('Start oppsynstur'), findsOneWidget);
      expect(find.text('Laster inn...'), findsOneWidget);

      await tester.pumpAndSettle();
      expect(find.text('Laster inn...'), findsNothing);
      expect(find.text('Start oppsynstur'), findsNWidgets(2));
      expect(find.text('Gård'), findsOneWidget);
      expect(find.text('Navn'), findsOneWidget);
    });
  });
}
