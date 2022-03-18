import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:web/login_register/login_widget.dart';
import 'package:web/main_tabs/main_tabs.dart';

import 'firebase_setup.dart';

void main() async {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  await firebaseSetup(createUser: true);

  testWidgets('Integration test login', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
        home: const Material(child: LoginForm()),
        routes: {MainTabs.route: (context) => const MainTabs()}));

    var emailField = find.byKey(const Key('inputEmail'));
    var passwordField = find.byKey(const Key('inputPassword'));
    var loginButton = find.text('Logg inn');

    // Assert user is not logged in
    expect(FirebaseAuth.instance.currentUser, null);

    // Enter login information and log in
    await tester.enterText(emailField, email);
    await tester.enterText(passwordField, password);
    await tester.tap(loginButton);
    await tester.pump(const Duration(seconds: 2));

    // Assert user is signed in
    expect(FirebaseAuth.instance.currentUser, isNotNull);

    // Assert LoginPage is no longer visible
    expect(find.text('Logg inn'), findsNothing);
  });
}
