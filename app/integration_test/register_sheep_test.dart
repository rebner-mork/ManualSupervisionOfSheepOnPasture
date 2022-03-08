import 'package:app/register/register_sheep.dart';
import 'package:app/utils/map_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:latlong2/latlong.dart';
import 'package:fluttericon/rpg_awesome_icons.dart';
import 'package:fluttericon/font_awesome5_icons.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  testWidgets('Distance: Initial layout and content',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
        home: RegisterSheep(
            'testFile', SpeechToText(), ValueNotifier(false), LatLng(40, 40))));

    expect(find.byType(BackButton), findsOneWidget);
    expect(find.text('Laster inn...'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    await tester.pumpAndSettle();

    expect(find.text('Laster inn...'), findsNothing);
    expect(find.byType(CircularProgressIndicator), findsNothing);

    expect(find.text('Avstandsregistrering sau'), findsOneWidget);

    expect(find.text('Antall'), findsOneWidget);
    expect(find.text('Sauer'), findsOneWidget);
    expect(find.text('Lam'), findsOneWidget);
    expect(find.text('Hvite'), findsOneWidget);
    expect(find.text('Svarte'), findsOneWidget);
    expect(find.text('Svart hode'), findsOneWidget);
    expect(find.byIcon(RpgAwesome.sheep), findsWidgets);
  });

  testWidgets('Close: Initial layout and content', (WidgetTester tester) async {
    LatLng devicePosition = await getDevicePosition();

    await tester.pumpWidget(MaterialApp(
        home: RegisterSheep(
            'testFile', SpeechToText(), ValueNotifier(false), devicePosition)));

    expect(find.byType(BackButton), findsOneWidget);
    expect(find.text('Laster inn...'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    await tester.pumpAndSettle();

    expect(find.text('Laster inn...'), findsNothing);
    expect(find.byType(CircularProgressIndicator), findsNothing);

    expect(find.text('Nærregistrering sau'), findsOneWidget);

    expect(find.text('Antall'), findsOneWidget);
    expect(find.text('Sauer'), findsOneWidget);
    expect(find.text('Lam'), findsOneWidget);
    expect(find.text('Hvite'), findsOneWidget);
    expect(find.text('Svarte'), findsOneWidget);
    expect(find.text('Svart hode'), findsOneWidget);
    expect(find.byIcon(RpgAwesome.sheep), findsWidgets);

    expect(find.text('Slips'), findsOneWidget);
    expect(find.byIcon(FontAwesome5.black_tie), findsWidgets);

    expect(find.text('Øremerker'), findsOneWidget);
    expect(find.byIcon(Icons.local_offer), findsWidgets);

    expect(find.text('Fullfør registrering'), findsOneWidget);
    expect(find.byType(FloatingActionButton), findsOneWidget);
  });

  testWidgets('Floating button changes on keyboard up',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
        home: RegisterSheep(
            'testFile', SpeechToText(), ValueNotifier(false), LatLng(40, 40))));

    await tester.pumpAndSettle();

    expect(find.text('Fullfør registrering'), findsOneWidget);
    expect(find.byIcon(Icons.check), findsNothing);

    await tester.showKeyboard(find.byType(TextFormField).first);
    await tester.pumpAndSettle();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('Fullfør registrering'), findsNothing);
    expect(find.byIcon(Icons.check), findsOneWidget);
  });

  testWidgets('Alert-dialog on back button', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
        home: RegisterSheep(
            'testFile', SpeechToText(), ValueNotifier(false), LatLng(40, 40))));

    await tester.pumpAndSettle();

    expect(find.byType(AlertDialog), findsNothing);

    await tester.tap(find.byType(BackButton));
    await tester.pump();

    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.textContaining('Ja'), findsOneWidget);
    expect(find.textContaining('Nei'), findsOneWidget);

    await tester.tap(find.textContaining('Ja'));
    await tester.pump();

    expect(find.byType(AlertDialog), findsNothing);
  });
}
