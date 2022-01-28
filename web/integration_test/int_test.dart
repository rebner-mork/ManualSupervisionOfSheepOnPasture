import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:web/main/main_page.dart';

void main() async {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseAuth.instance.useAuthEmulator('10.0.2.2', 9099);
  FirebaseFirestore.instance.useFirestoreEmulator('100.2.2', 8080);

  testWidgets('INTEGRATION', (WidgetTester tester) async {
    // Create user
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: 'test@gmail.com', password: '12345678');
    await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: 'test@gmail.com', password: '12345678');

    await tester.pumpWidget(const MaterialApp(home: MainPage()));
    expect(find.text('Årsrapporter'), findsOneWidget);
    expect(find.text('Oppsynsturer'), findsOneWidget);
    expect(find.text('Min side'), findsOneWidget);
  });
}
