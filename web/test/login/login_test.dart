import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:web/login/login_page.dart';

void main() {
  group('Widget tests', () {
    testWidgets('Initial layout and content', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: LoginPage()));

      // input fieds and buttons
      expect(find.text('Logg inn'), findsOneWidget);
      expect(find.text('E-post'), findsOneWidget);
      expect(find.text('Passord'), findsOneWidget);
      expect(find.text('Opprett brukerkonto'), findsOneWidget);

      // Icons
      expect(find.byIcon(Icons.account_circle), findsOneWidget);
      expect(find.byIcon(Icons.visibility_off), findsOneWidget);
      expect(find.byIcon(Icons.mail), findsOneWidget);
      expect(find.byIcon(Icons.lock), findsOneWidget);

      // Do not find input feedback
      expect(find.text('Skriv e-post'), findsNothing);
      expect(find.text('Skriv gyldig e-post'), findsNothing);
      expect(find.text('Skriv passord'), findsNothing);
      expect(find.text('Passord må inneholde minst 8 tegn'), findsNothing);
      expect(find.text('E-post og/eller passord er ugyldig'), findsNothing);

      //Picture
      //https://github.com/flutter/flutter/issues/38997
    });

    testWidgets('Invalid inputs', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: LoginPage()));

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
      TestWidgetsFlutterBinding.ensureInitialized();
      tester.binding.window.physicalSizeTestValue = const Size(1024, 768);
      tester.binding.window.devicePixelRatioTestValue = 1.0;
      await tester.pumpWidget(const MaterialApp(home: LoginPage()));
      await tester.enterText(
          find.byKey(const Key('inputPassword')), '12345678');

      // Password is obscure
      var textFormField = find.descendant(
          of: find.byKey(const Key('inputPassword')),
          matching: find.byType(EditableText));
      expect(tester.widget<EditableText>(textFormField).obscureText, isTrue);

      // Password is not obscure
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
