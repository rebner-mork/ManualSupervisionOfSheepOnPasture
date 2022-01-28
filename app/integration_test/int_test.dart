import 'dart:io';

import 'package:app/login/login_page.dart';
import 'package:app/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

// This test can only run on an emulator (not on a pysical device)
void main() async {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  testWidgets('Integration test', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: LoginPage(null)));
    String host = Platform.isAndroid ? '10.0.2.2' : 'localhost';
    FirebaseAuth.instance.useAuthEmulator(host, 9099);

    var emailField = find.byKey(const Key('inputEmail'));
    var passwordField = find.byKey(const Key('inputPassword'));
    var loginButton = find.text('Logg inn');

    // Assert user is not logged in
    expect(FirebaseAuth.instance.currentUser, null);

    // Create user
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: 'test@gmail.com', password: '12345678');
    } catch (e) {
      fail(e.toString());
    }

    // Enter login information and log in
    await tester.enterText(emailField, 'test@gmail.com');
    await tester.enterText(passwordField, '12345678');
    await tester.tap(loginButton);
    await tester.pump();

    // Assert user is logged in
    expect(FirebaseAuth.instance.currentUser, isNotNull);
    expect(FirebaseAuth.instance.currentUser, const TypeMatcher<User>());
  });
}
