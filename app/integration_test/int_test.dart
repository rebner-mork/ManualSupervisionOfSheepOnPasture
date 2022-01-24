import 'dart:io';

import 'package:app/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

// This test can only run on an emulator (not on a physical device)
void main() async {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  testWidgets('Integration', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp(null));
    String host = Platform.isAndroid ? '10.0.2.2' : 'localhost';
    FirebaseAuth.instance.useAuthEmulator(host, 9099);
    FirebaseFirestore.instance.useFirestoreEmulator('10.0.2.2', 8080);

    var registerButton = find.text('Opprett bruker');
    var emailField = find.byKey(const Key('inputEmail'));
    var passwordOneField = find.byKey(const Key('inputPasswordOne'));
    var passwordTwoField = find.byKey(const Key('inputPasswordTwo'));
    var phoneField = find.byKey(const Key('inputPhone'));

    // Assert user does not exist
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: 'test@gmail.com', password: '12345678');
      fail('signIn did not throw exception as expected');
    } on FirebaseAuthException catch (e) {
      if (e.code != 'user-not-found') {
        fail('User already exists');
      }
    }

    // Register user
    await tester.enterText(emailField, 'test@gmail.com');
    await tester.enterText(passwordOneField, '12345678');
    await tester.enterText(passwordTwoField, '12345678');
    await tester.enterText(phoneField, '12345678');

    await tester.tap(registerButton);
    await tester.pump();

    // Assert user exists
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: 'test@gmail.com', password: '12345678');
    } catch (e) {
      fail(e.toString());
    }

    // Assert phone number exists
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    QuerySnapshot user =
        await users.where('email', isEqualTo: 'test@gmail.com').get();

    expect(user.docs.first.get('email'), 'test@gmail.com');
  });
}
