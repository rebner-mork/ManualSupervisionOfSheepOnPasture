import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:web/my_page/my_farm_page.dart';

import 'firebase_setup.dart';

void main() async {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  await firebaseSetup(createUser: true, signIn: true);

  String farmName = 'testFarmName';
  String farmAddress = 'testFarmAddress';
  Duration waitDuration = const Duration(seconds: 2);

  testWidgets('Initial layout and content', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
        home:
            Material(child: Row(children: const [Expanded(child: MyFarm())]))));

    expect(find.text('Laster gårdsinformasjon...'), findsOneWidget);
    await tester.pump(const Duration(seconds: 5));
    expect(find.text('Laster gårdsinformasjon...'), findsNothing);

    expect(find.text('Gårdsnavn'), findsOneWidget);
    expect(find.text('Navn'), findsOneWidget);
    expect(find.text('Gårdsadresse'), findsOneWidget);
    expect(find.text('Adresse'), findsOneWidget);

    expect(find.byIcon(Icons.badge), findsOneWidget);
    expect(find.byIcon(Icons.place), findsOneWidget);
  });

  testWidgets('Invalid input', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
        home:
            Material(child: Row(children: const [Expanded(child: MyFarm())]))));
    await tester.pump(waitDuration);

    // No input
    await tester.tap(find.text('Lagre'));
    await tester.pump();

    expect(find.text('Skriv gårdsnavn'), findsOneWidget);
    expect(find.text('Skriv gårdsadresse'), findsOneWidget);

    // First input only
    await tester.enterText(find.byKey(const Key('inputFarmName')), farmName);
    await tester.pump();

    expect(find.text('Skriv gårdsnavn'), findsNothing);
    expect(find.text('Skriv gårdsadresse'), findsOneWidget);

    // Second input only
    await tester.enterText(find.byKey(const Key('inputFarmName')), '');
    await tester.enterText(
        find.byKey(const Key('inputFarmAddress')), farmAddress);
    await tester.pump();

    expect(find.text('Skriv gårdsnavn'), findsOneWidget);
    expect(find.text('Skriv gårdsadresse'), findsNothing);
  });

  testWidgets('Save farm info', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
        home:
            Material(child: Row(children: const [Expanded(child: MyFarm())]))));

    await tester.enterText(find.byKey(const Key('inputFarmName')), farmName);
    await tester.enterText(
        find.byKey(const Key('inputFarmAddress')), farmAddress);
    await tester.tap(find.text('Lagre'));
    await tester.pump(waitDuration);

    expect(find.text('Gårdsinformasjon lagret'), findsOneWidget);
  });

  testWidgets('Farm info exists', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
        home:
            Material(child: Row(children: const [Expanded(child: MyFarm())]))));
    await tester.pump(waitDuration);

    expect(find.text('Laster data...'), findsNothing);
    expect(find.text(farmName), findsOneWidget);
    expect(find.text(farmAddress), findsOneWidget);
  });
}
