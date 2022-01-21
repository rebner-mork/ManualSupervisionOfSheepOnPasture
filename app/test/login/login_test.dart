import 'package:app/utils/authentication.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:app/main.dart';

void main() {
  group('Unit tests', () {
    test('Email validator', () {
      expect(validateEmail(''), 'Skriv e-post');
      expect(validateEmail('x'), 'Skriv gyldig e-post');
      expect(validateEmail('x@x'), 'Skriv gyldig e-post');
      expect(validateEmail('x@x.'), 'Skriv gyldig e-post');

      expect(validateEmail('x@x.no'), null);
      expect(validateEmail('test@gmail.no'), null);
      expect(validateEmail('test@gmail.com'), null);
      expect(validateEmail('test@hotmail.com'), null);
      expect(validateEmail('test@sfjbb.net'), null);
    });
    test('Password validator', () {
      expect(validatePassword(''), 'Skriv passord');
      expect(validatePassword('1234567'), 'Passord må inneholde minst 8 tegn');
      expect(validatePassword('12345678'), null);
    });
  });

  group('Widget tests', () {
    testWidgets('Initial layout and content', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp(null));

      expect(find.text('Logg inn'), findsOneWidget);
      expect(find.text('E-post'), findsOneWidget);
      expect(find.text('Passord'), findsOneWidget);
      expect(find.text('Registrer ny bruker'), findsOneWidget);

      expect(find.byIcon(Icons.account_circle), findsOneWidget);
      expect(find.byIcon(Icons.visibility_off), findsOneWidget);
      expect(find.byIcon(Icons.mail), findsOneWidget);
      expect(find.byIcon(Icons.lock), findsOneWidget);

      expect(find.text('Skriv e-post'), findsNothing);
      expect(find.text('Skriv gyldig e-post'), findsNothing);
      expect(find.text('Skriv passord'), findsNothing);
      expect(find.text('Passord må inneholde minst 8 tegn'), findsNothing);
      expect(find.text('E-post eller passord er ugyldig'), findsNothing);
    });

    testWidgets('Invalid inputs', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp(null));

      var loginButton = find.text('Logg inn');
      var emailField = find.byKey(const Key('inputEmail'));
      var passwordField = find.byKey(const Key('inputPassword'));

      // No input
      await pressLoginButton(tester, loginButton);
      expect(find.text('Skriv e-post'), findsOneWidget);
      expect(find.text('Skriv passord'), findsOneWidget);

      // One empty input at a time
      await tester.enterText(emailField, 'test@gmail.com');
      await pressLoginButton(tester, loginButton);
      expect(find.text('Skriv e-post'), findsNothing);
      expect(find.text('Skriv passord'), findsOneWidget);

      await tester.enterText(emailField, '');
      await tester.enterText(passwordField, '12345678');
      await pressLoginButton(tester, loginButton);
      expect(find.text('Skriv e-post'), findsOneWidget);
      expect(find.text('Skriv passord'), findsNothing);

      await tester.enterText(emailField, '');
      await pressLoginButton(tester, loginButton);
      expect(find.text('Skriv e-post'), findsOneWidget);
      expect(find.text('Skriv passord'), findsNothing);

      // Short password
      await tester.enterText(passwordField, '12');
      await pressLoginButton(tester, loginButton);
      expect(find.text('Passord må inneholde minst 8 tegn'), findsOneWidget);

      // Invalid email-format
      await tester.enterText(emailField, 'test@');
      await pressLoginButton(tester, loginButton);
      expect((find.text('Skriv gyldig e-post')), findsOneWidget);
    });

    testWidgets('Password obscurity', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp(null));
      await tester.enterText(
          find.byKey(const Key('inputPassword')), '12345678');

      // Password is obscure
      final textFormField = find.descendant(
          of: find.byKey(const Key('inputPassword')),
          matching: find.byType(EditableText));
      final input = tester.widget<EditableText>(textFormField);
      expect(input.obscureText, isTrue);

      // Password is not obscure
      await tester.tap(find.byIcon(Icons.visibility_off));
      await tester.pump();
      expect(find.text('12345678'), findsOneWidget);
      expect(find.byIcon(Icons.visibility), findsOneWidget);
    });
  });
}

Future pressLoginButton(WidgetTester tester, Finder loginButton) async {
  await tester.tap(loginButton);
  await tester.pump();
}
