import 'package:app/providers/settings_provider.dart';
import 'package:app/register/register_sheep.dart';
import 'package:app/utils/constants.dart';
import 'package:app/utils/map_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:provider/provider.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:latlong2/latlong.dart';
import 'package:fluttericon/font_awesome5_icons.dart';

final Map<String, bool> eartags = {
  Colors.red.value.toRadixString(16): true,
  Colors.blue.value.toRadixString(16): false
};

final Map<String, int> ties = {
  Colors.transparent.value.toRadixString(16): 0,
  Colors.yellow.value.toRadixString(16): 1
};

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  testWidgets('Distance: Initial layout and content',
      (WidgetTester tester) async {
    await setConstants();
    await tester.pumpWidget(MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => SettingsProvider())
        ],
        child: MaterialApp(
            home: RegisterSheep(
                stt: SpeechToText(),
                ongoingDialog: ValueNotifier(false),
                sheepPosition: LatLng(40, 40),
                eartags: eartags,
                ties: ties))));

    expect(find.byType(BackButton), findsOneWidget);
    expect(find.text('Laster inn...'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    await tester.pumpAndSettle();

    expect(find.text('Laster inn...'), findsNothing);
    expect(find.byType(CircularProgressIndicator), findsNothing);

    expect(find.text('Avstandsregistrering sau'), findsOneWidget);

    expect(find.text('Antall'), findsOneWidget);
    expect(find.text('Totalt'), findsOneWidget);
    expect(find.text('Lam'), findsOneWidget);
    expect(find.text('Hvite'), findsOneWidget);
    expect(find.text('Svarte'), findsOneWidget);
    expect(find.text('Svart hode'), findsOneWidget);
  });

  testWidgets('Close: Initial layout and content', (WidgetTester tester) async {
    LatLng devicePosition = await getDevicePosition();

    await tester.pumpWidget(MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => SettingsProvider())
        ],
        child: MaterialApp(
            home: RegisterSheep(
                stt: SpeechToText(),
                ongoingDialog: ValueNotifier(false),
                sheepPosition: devicePosition,
                eartags: eartags,
                ties: ties))));

    expect(find.byType(BackButton), findsOneWidget);
    expect(find.text('Laster inn...'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    await tester.pumpAndSettle();

    expect(find.text('Laster inn...'), findsNothing);
    expect(find.byType(CircularProgressIndicator), findsNothing);

    expect(find.text('Nærregistrering sau'), findsOneWidget);

    expect(find.text('Antall'), findsOneWidget);
    expect(find.text('Totalt'), findsOneWidget);
    expect(find.text('Lam'), findsOneWidget);
    expect(find.text('Hvite'), findsOneWidget);
    expect(find.text('Svarte'), findsOneWidget);
    expect(find.text('Svart hode'), findsOneWidget);

    expect(find.text('Slips'), findsOneWidget);
    expect(find.byIcon(FontAwesome5.black_tie), findsWidgets);
    expect(find.text('Ingen'), findsOneWidget);
    expect(find.text('Gule'), findsOneWidget);

    expect(find.text('Øremerker'), findsOneWidget);
    expect(find.byIcon(Icons.local_offer), findsWidgets);
    expect(find.text('Røde'), findsOneWidget);
    expect(find.text('Blå'), findsOneWidget);

    expect(find.text('Fullfør registrering'), findsOneWidget);
    expect(find.byType(FloatingActionButton), findsOneWidget);
  });

  testWidgets('Floating button changes on keyboard up',
      (WidgetTester tester) async {
    await tester.pumpWidget(MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => SettingsProvider())
        ],
        child: MaterialApp(
            home: RegisterSheep(
                stt: SpeechToText(),
                ongoingDialog: ValueNotifier(false),
                sheepPosition: LatLng(40, 40),
                eartags: eartags,
                ties: ties))));

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
    await tester.pumpWidget(MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => SettingsProvider())
        ],
        child: MaterialApp(
            home: RegisterSheep(
                stt: SpeechToText(),
                ongoingDialog: ValueNotifier(false),
                sheepPosition: LatLng(40, 40),
                eartags: eartags,
                ties: ties))));

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
