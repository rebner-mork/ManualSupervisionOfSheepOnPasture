import 'package:app/register/register_sheep.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  testWidgets('Floating button changes on keyboard up',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: RegisterSheep('testFile')));

    expect(find.text('Fullfør registrering'), findsOneWidget);
    expect(find.byIcon(Icons.check), findsNothing);

    await tester.showKeyboard(find.byType(TextFormField).first);
    await tester.pumpAndSettle();

    expect(find.text('Fullfør registrering'), findsNothing);
    expect(find.byType(FloatingActionButton), findsOneWidget);
    expect(find.byIcon(Icons.check), findsOneWidget);
  });
}
