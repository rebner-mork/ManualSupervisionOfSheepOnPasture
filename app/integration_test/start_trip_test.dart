import 'package:app/trip/start_trip_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'firebase_setup.dart';

void main() async {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  await firebaseSetup(createUser: true, signIn: true);
  await setUpFarm();

  group('Start trip happy day scenario', () {
    testWidgets('Initial layout', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: StartTripPage()));

      expect(find.text('Start oppsynstur'), findsOneWidget);
      expect(find.text('Laster inn...'), findsOneWidget);
      expect(find.text('Gård'), findsNothing);
      expect(find.text('Kart'), findsNothing);

      await tester.pumpAndSettle();

      expect(find.text('Laster inn...'), findsNothing);
      expect(find.text('Start oppsynstur'), findsNWidgets(2));
      expect(find.text('Gård'), findsOneWidget);
      expect(find.text('Kart'), findsOneWidget);

      expect(find.text(farmName), findsOneWidget);
      expect(find.text(validMaps.keys.first), findsOneWidget);
      expect(find.text(validMaps.keys.elementAt(1)), findsOneWidget);

      expect(find.byIcon(Icons.download_for_offline_outlined), findsOneWidget);
    });

    testWidgets('Download map', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: StartTripPage()));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.download_for_offline_outlined), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);

      await tester.tap(find.byIcon(Icons.download_for_offline_outlined));
      await tester.pump();

      expect(find.byIcon(Icons.download_for_offline_outlined), findsNothing);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Laster ned kart...'), findsOneWidget);

      await tester.pumpAndSettle();
      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.byIcon(Icons.file_download_done), findsOneWidget);
      expect(find.text('Kartet \'${validMaps.keys.first}\' er nedlastet.'),
          findsOneWidget);
    });
  });

  group('Start trip with no maps defined', () {
    testWidgets('Initial layout', (WidgetTester tester) async {
      await setUpFarm(maps: null);
      await tester.pumpWidget(const MaterialApp(home: StartTripPage()));

      expect(find.text('Start oppsynstur'), findsOneWidget);
      expect(find.text('Laster inn...'), findsOneWidget);
      expect(find.text('Gård'), findsNothing);
      expect(find.text('Kart'), findsNothing);

      await tester.pumpAndSettle();

      expect(find.text('Laster inn...'), findsNothing);
      expect(find.text('Start oppsynstur'), findsNWidgets(2));
      expect(find.text('Gård'), findsOneWidget);
      expect(find.text('Kart'), findsOneWidget);
      expect(find.text('Gården \'$farmName\' har ikke definert noen kart'),
          findsOneWidget);
    });
  });

  group('Start trip without being registered as personnel on any farm', () {
    testWidgets('Initial layout', (WidgetTester tester) async {
      try {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: 'testing@gmail.no', password: password);
      } on FirebaseAuthException catch (_) {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: 'testing@gmail.no', password: password);
      }

      await tester.pumpWidget(const MaterialApp(home: StartTripPage()));
      await tester.pumpAndSettle();

      expect(find.text('Laster inn...'), findsNothing);
      expect(
          find.text(
              'Du er ikke registrert som oppsynspersonell hos noen gård. Ta kontakt med sauebonde.'),
          findsOneWidget);
    });
  });
}