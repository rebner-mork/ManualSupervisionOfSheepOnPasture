import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:web/main/main_page.dart';
import 'package:web/my_page/my_page.dart';

void main() async {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  FirebaseAuth.instance.useAuthEmulator('10.0.2.2', 9099);
  FirebaseFirestore.instance.useFirestoreEmulator('100.2.2', 8080);

  try {
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: 'test@gmail.com', password: '12345678');
  } catch (_) {}

  group('MainPage', () {
    testWidgets('Initial layout and content', (WidgetTester tester) async {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: 'test@gmail.com', password: '12345678');
      await tester.pumpWidget(const MaterialApp(home: MainPage()));
      await tester.pumpAndSettle();

      expect(find.text('Årsrapporter'), findsOneWidget);
      expect(find.text('Oppsynsturer'), findsOneWidget);
      expect(find.text('Min side'), findsOneWidget);

      expect(find.text('Gård'), findsOneWidget);
      expect(find.text('Øremerker'), findsOneWidget);
      expect(find.text('Slips'), findsOneWidget);
      expect(find.text('Oppsynspersonell'), findsOneWidget);

      /*expect(find.byIcon(Icons.gite), findsOneWidget);
      expect(find.byIcon(Icons.local_offer_outlined), findsOneWidget);
      expect(find.byIcon(Icons.filter_alt), findsOneWidget);
      expect(find.byIcon(Icons.groups), findsOneWidget);
      
      await tester.tap(find.byIcon(Icons.groups_outlined));
      await tester.pump();

      expect(find.byIcon(Icons.groups), findsNothing);
      expect(find.byIcon(Icons.groups_outlined), findsOneWidget);*/
    });
  });
}
