import 'package:app/providers/settings_provider.dart';
import 'package:app/trip/start_trip_page.dart';
import 'package:app/utils/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:provider/provider.dart';

import 'firebase_setup.dart';

void main() async {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  await firebaseSetup(createUser: true, signIn: true);
  await setUpFarm();
  setConstants();

  group('Start trip happy day scenario', () {
    testWidgets('Initial layout', (WidgetTester tester) async {
      await tester.pumpWidget(MultiProvider(providers: [
        ChangeNotifierProvider(create: (context) => SettingsProvider())
      ], child: const MaterialApp(home: StartTripPage())));

      expect(find.text('Start oppsynstur'), findsOneWidget);
      expect(find.text('Laster inn...'), findsOneWidget);
      expect(find.text('Gård'), findsNothing);
      expect(find.text('Kart'), findsNothing);

      await tester.pumpAndSettle(const Duration(milliseconds: 1500));
      await tester.pump(const Duration(milliseconds: 500));

      expect(find.text('Laster inn...'), findsNothing);
      expect(find.text('Start oppsynstur'), findsNWidgets(2));
      expect(find.text('Gård'), findsOneWidget);
      expect(find.text('Kart'), findsOneWidget);

      expect(find.text(farmName), findsOneWidget);
      expect(find.text(validMaps.keys.first), findsOneWidget);
      expect(find.text(validMaps.keys.last), findsOneWidget);
      expect(find.byIcon(StartTripPage.notDownloadedIcon), findsOneWidget);
    });

    testWidgets('Download map', (WidgetTester tester) async {
      await tester.pumpWidget(MultiProvider(providers: [
        ChangeNotifierProvider(create: (context) => SettingsProvider())
      ], child: const MaterialApp(home: StartTripPage())));
      await tester.pumpAndSettle();
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.byIcon(StartTripPage.notDownloadedIcon), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.byType(LinearProgressIndicator), findsNothing);

      await tester.tap(find.byIcon(StartTripPage.notDownloadedIcon));
      await tester.pump();

      expect(find.byIcon(StartTripPage.notDownloadedIcon), findsNothing);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.byType(LinearProgressIndicator), findsOneWidget);
      expect(find.text('Laster ned kart...'), findsOneWidget);

      await tester.pumpAndSettle();
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.byType(LinearProgressIndicator), findsNothing);
      expect(find.byIcon(StartTripPage.downloadedIcon), findsOneWidget);
      expect(find.text('Kartet \'${validMaps.keys.first}\' er nedlastet.'),
          findsOneWidget);
    });
  });

  group('Start trip with no maps defined', () {
    testWidgets('Initial layout', (WidgetTester tester) async {
      await setUpFarm(maps: null);
      await tester.pumpWidget(MultiProvider(providers: [
        ChangeNotifierProvider(create: (context) => SettingsProvider())
      ], child: const MaterialApp(home: StartTripPage())));

      expect(find.text('Start oppsynstur'), findsOneWidget);
      expect(find.text('Laster inn...'), findsOneWidget);
      expect(find.text('Gård'), findsNothing);
      expect(find.text('Kart'), findsNothing);

      await tester.pumpAndSettle();
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text('Laster inn...'), findsNothing);
      expect(find.text('Start oppsynstur'), findsNWidgets(2));
      expect(find.text('Gård'), findsOneWidget);
      expect(find.text('Kart'), findsNothing);
      expect(
          find.text(
              'Gården har ikke definert noen kart,\noppsynstur kan dermed ikke starte.'),
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

      await tester.pumpWidget(MultiProvider(providers: [
        ChangeNotifierProvider(create: (context) => SettingsProvider())
      ], child: const MaterialApp(home: StartTripPage())));
      await tester.pumpAndSettle();
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text('Laster inn...'), findsNothing);
      expect(
          find.text(
              'Du er ikke registrert som oppsynsperson,\nta kontakt med sauebonde.'),
          findsOneWidget);
    });
  });
}
