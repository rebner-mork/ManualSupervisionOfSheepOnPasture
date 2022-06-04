import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:web/login_or_sign_up/sign_up_widget.dart';

void main() {
  group('Widget tests', () {
    TestWidgetsFlutterBinding.ensureInitialized();
    testWidgets('Initial layout and content', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: SignUpWidget()));
      TestWidgetsFlutterBinding.ensureInitialized();

      expect(find.text('E-post'), findsOneWidget);
      expect(find.text('Passord'), findsOneWidget);
      expect(find.text('Gjenta passord'), findsOneWidget);
      expect(find.text('Telefon'), findsOneWidget);
      expect(find.text('Opprett brukerkonto'), findsOneWidget);

      expect(find.byIcon(Icons.account_circle), findsOneWidget);
      expect(find.byIcon(Icons.visibility_off), findsNWidgets(2));
      expect(find.byIcon(Icons.badge), findsOneWidget);
      expect(find.byIcon(Icons.mail), findsOneWidget);
      expect(find.byIcon(Icons.lock), findsNWidgets(2));
      expect(find.byIcon(Icons.phone), findsOneWidget);

      expect(find.text('Skriv e-post'), findsNothing);
      expect(find.text('Skriv gyldig e-post'), findsNothing);
      expect(find.text('Skriv passord'), findsNothing);
      expect(find.text('Passord må inneholde minst 8 tegn'), findsNothing);
      expect(find.text('Passordene er ikke like'), findsNothing);
      expect(find.text('Skriv telefonnummer'), findsNothing);
      expect(
          find.text('Telefonnummer må inneholde minst 8 siffer'), findsNothing);
      expect(find.text('Telefonnummer må kun bestå av siffer'), findsNothing);

      expect(find.text('E-posten er allerede i bruk'), findsNothing);
      expect(find.text('Skriv gyldig e-post'), findsNothing);
      expect(find.text('Skriv sterkere passord'), findsNothing);
    });

    testWidgets('Invalid inputs', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(
          home: SingleChildScrollView(child: SignUpWidget())));
      TestWidgetsFlutterBinding.ensureInitialized();

      var registerButton = find.text('Opprett brukerkonto');
      var emailField = find.byKey(const Key('inputEmail'));
      var passwordOneField = find.byKey(const Key('inputPasswordOne'));
      var passwordTwoField = find.byKey(const Key('inputPasswordTwo'));
      var phoneField = find.byKey(const Key('inputPhone'));

      // No input
      await pressRegisterButton(tester, registerButton);
      expect(find.text('E-post'), findsOneWidget);
      expect(find.text('Skriv passord'), findsNWidgets(2));
      expect(find.text('Skriv telefonnummer'), findsOneWidget);

      // One empty input at a time
      await tester.enterText(emailField, 'test@gmail.com');
      await tester.pump();
      expect(find.text('Skriv e-post'), findsNothing);
      expect(find.text('Skriv passord'), findsNWidgets(2));
      expect(find.text('Skriv telefonnummer'), findsOneWidget);

      await tester.enterText(emailField, '');
      await tester.enterText(passwordOneField, '12345678');
      await tester.pump();
      expect(find.text('Skriv e-post'), findsOneWidget);
      expect(find.text('Skriv passord'), findsNothing);
      expect(find.text('Skriv telefonnummer'), findsOneWidget);

      await tester.enterText(passwordOneField, '');
      await tester.enterText(passwordTwoField, '12345678');
      await tester.pump();
      expect(find.text('Skriv e-post'), findsOneWidget);
      expect(find.text('Skriv passord'), findsOneWidget);
      expect(find.text('Passordene er ikke like'), findsOneWidget);
      expect(find.text('Skriv telefonnummer'), findsOneWidget);

      await tester.enterText(phoneField, '12345678');
      await tester.enterText(passwordTwoField, '');
      await tester.pump();
      expect(find.text('Skriv e-post'), findsOneWidget);
      expect(find.text('Skriv passord'), findsNWidgets(2));
      expect(find.text('Skriv telefonnummer'), findsNothing);
    });
  });

  testWidgets('Password obscurity', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: SignUpWidget()));
    TestWidgetsFlutterBinding.ensureInitialized();

    await tester.enterText(
        find.byKey(const Key('inputPasswordOne')), '12345678');
    await tester.enterText(
        find.byKey(const Key('inputPasswordTwo')), '12345678');

    // Assert passwords are obscure
    var textFormFieldOne = find.descendant(
        of: find.byKey(const Key('inputPasswordOne')),
        matching: find.byType(EditableText));

    var textFormFieldTwo = find.descendant(
        of: find.byKey(const Key('inputPasswordTwo')),
        matching: find.byType(EditableText));

    expect(tester.widget<EditableText>(textFormFieldOne).obscureText, isTrue);
    expect(tester.widget<EditableText>(textFormFieldTwo).obscureText, isTrue);
    expect(find.byIcon(Icons.visibility_off), findsNWidgets(2));

    // Assert passwords are not obscure
    await tester.tap(find.byIcon(Icons.visibility_off).first);
    await tester.pump();

    textFormFieldOne = find.descendant(
        of: find.byKey(const Key('inputPasswordOne')),
        matching: find.byType(EditableText));

    textFormFieldTwo = find.descendant(
        of: find.byKey(const Key('inputPasswordTwo')),
        matching: find.byType(EditableText));

    expect(tester.widget<EditableText>(textFormFieldOne).obscureText, isFalse);
    expect(tester.widget<EditableText>(textFormFieldTwo).obscureText, isFalse);
    expect(find.byIcon(Icons.visibility), findsNWidgets(2));
  });
}

Future pressRegisterButton(WidgetTester tester, Finder registerButton) async {
  await tester.tap(registerButton);
  await tester.pump();
}
