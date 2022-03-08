import 'package:app/register/register_sheep.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:speech_to_text/speech_to_text.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  testWidgets('Floating button changes on keyboard up',
      (WidgetTester tester) async {
    await tester.pumpWidget(
        MaterialApp(home: RegisterSheep(SpeechToText(), ValueNotifier(false))));

    expect(find.text('Fullfør registrering'), findsOneWidget);
    expect(find.byIcon(Icons.check), findsNothing);

    await tester.showKeyboard(find.byType(TextFormField).first);
    await tester.pumpAndSettle();

    expect(find.text('Fullfør registrering'), findsNothing);
    expect(find.byIcon(Icons.check), findsOneWidget);
  });
}
