import 'package:app/register/register_sheep.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fluttericon/rpg_awesome_icons.dart';
import 'package:fluttericon/font_awesome5_icons.dart';

void main() {
  group('Widget tests', () {
    TestWidgetsFlutterBinding.ensureInitialized();
    testWidgets('Initial layout and content', (WidgetTester tester) async {
      await tester
          .pumpWidget(const MaterialApp(home: RegisterSheep('testFile')));

      expect(find.byType(BackButton), findsOneWidget);
      expect(find.text('Registrer sau'), findsOneWidget);

      expect(find.text('Antall'), findsOneWidget);
      expect(find.byIcon(RpgAwesome.sheep), findsWidgets);

      expect(find.text('Slips'), findsOneWidget);
      expect(find.byIcon(FontAwesome5.black_tie), findsWidgets);

      expect(find.text('Øremerker'), findsOneWidget);
      expect(find.byIcon(Icons.local_offer), findsWidgets);
    });

    testWidgets('', (WidgetTester tester) async {
      await tester
          .pumpWidget(const MaterialApp(home: RegisterSheep('testFile')));
    });
  });
}
