import 'package:app/utils/field_validation.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Unit tests for field validation', () {
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

    test('Equal password validator', () {
      expect(validatePasswords('', ''), 'Skriv passord');
      expect(validatePasswords('1', '1'), 'Passord må inneholde minst 8 tegn');
      expect(validatePasswords('1', '2'), 'Passordene er ikke like');
      expect(
          validatePasswords('12345678', '87654321'), 'Passordene er ikke like');
      expect(validatePasswords('11111111', '11111111'), null);
    });

    test('Phone validator', () {
      expect(validatePhone(''), 'Skriv telefonnummer');
      expect(validatePhone('1'), 'Telefonnummer må inneholde minst 8 siffer');
      expect(validatePhone('a'), 'Telefonnummer må kun bestå av siffer');
      expect(validatePhone('12345678'), null);
    });
  });
}
