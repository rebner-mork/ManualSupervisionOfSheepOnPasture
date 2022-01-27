import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:app/main.dart';

void main() {
  group('Widget tests', () {
    testWidgets('Initial layout and content', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());

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
      await tester.pumpWidget(const MyApp());

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
      await tester.pumpWidget(const MyApp());
      await tester.enterText(
          find.byKey(const Key('inputPassword')), '12345678');

      // Assert password is obscure
      var textFormField = find.descendant(
          of: find.byKey(const Key('inputPassword')),
          matching: find.byType(EditableText));
      expect(tester.widget<EditableText>(textFormField).obscureText, isTrue);

      // Assert password is not obscure
      await tester.tap(find.byIcon(Icons.visibility_off));
      await tester.pump();

      textFormField = find.descendant(
          of: find.byKey(const Key('inputPassword')),
          matching: find.byType(EditableText));
      expect(tester.widget<EditableText>(textFormField).obscureText, isFalse);
      expect(find.byIcon(Icons.visibility), findsOneWidget);
    });
  });
}

Future pressLoginButton(WidgetTester tester, Finder loginButton) async {
  await tester.tap(loginButton);
  await tester.pump();
}
