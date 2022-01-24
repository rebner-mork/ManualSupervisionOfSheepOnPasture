import 'dart:io';

import 'package:app/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'dart:developer' as logger;

// This test can onlu run on an emulator (not on a physical device)
void main() async {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  testWidgets('INTEGRATION', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp(null));
    String host = Platform.isAndroid ? '10.0.2.2' : 'localhost';
    FirebaseAuth.instance.useAuthEmulator(host, 9099);

    var registerButton = find.text('Opprett bruker');
    var emailField = find.byKey(const Key('inputEmail'));
    var passwordField = find.byKey(const Key('inputPassword'));
    var phoneField = find.byKey(const Key('inputPhone'));

    bool userExists = false;

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: 'testregistrert@gmail.com', password: '12345678');
      userExists = true;
    } catch (e) {
      logger.log(e.toString()); // TODO
    }
    expect(userExists, false);

    await tester.enterText(emailField, 'testregistrert@gmail.com');
    await tester.enterText(passwordField, '12345678');
    await tester.enterText(phoneField, '12345678');

    await tester.tap(registerButton);
    await tester.pump();

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: 'testregistrert@gmail.com', password: '12345678');
      userExists = true;
    } catch (e) {
      logger.log(e.toString());
    }
    expect(userExists, true);
  });
}
