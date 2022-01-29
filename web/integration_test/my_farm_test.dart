import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:web/my_page/my_farm.dart';

import 'firebaseSetup.dart';

void main() async {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  await firebaseSetup();

  testWidgets('Initial layout and content', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
        home:
            Material(child: Row(children: const [Expanded(child: MyFarm())]))));

    var saveButton = find.text('Lagre');

    /*expect(find.text('Laster data...'), findsOneWidget);
    await tester.pump();
    expect(find.text('Laster data...'), findsNothing);*/

    expect(find.text('Gårdsnavn'), findsOneWidget);
    expect(find.text('Navn'), findsOneWidget);
    expect(find.text('Gårdsadresse'), findsOneWidget);
    expect(find.text('Adresse'), findsOneWidget);

    expect(find.byIcon(Icons.badge), findsOneWidget);
    expect(find.byIcon(Icons.place), findsOneWidget);
  });
}
