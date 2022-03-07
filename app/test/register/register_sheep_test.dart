import 'package:app/register/register_sheep.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fluttericon/rpg_awesome_icons.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:speech_to_text/speech_to_text.dart';

void main() {
  group('Widget tests', () {
    TestWidgetsFlutterBinding.ensureInitialized();
    testWidgets('Initial layout and content', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
          home:
              RegisterSheep('testFile', SpeechToText(), ValueNotifier(false))));

      expect(find.byType(BackButton), findsOneWidget);
      expect(find.text('Registrer sau'), findsOneWidget);

      expect(find.text('Antall'), findsOneWidget);
      expect(find.byIcon(RpgAwesome.sheep), findsWidgets);

      expect(find.text('Slips'), findsOneWidget);
      expect(find.byIcon(FontAwesome5.black_tie), findsWidgets);

      expect(find.text('Øremerker'), findsOneWidget);
      expect(find.byIcon(Icons.local_offer), findsWidgets);

      expect(find.text('Fullfør registrering'), findsOneWidget);
      expect(find.byType(FloatingActionButton), findsOneWidget);
    });

    testWidgets('Alert-dialog on back button', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
          home:
              RegisterSheep('testFile', SpeechToText(), ValueNotifier(false))));

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
  });
}
