import 'package:app/utils/field_validation.dart';
import 'package:flutter_test/flutter_test.dart';

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
}
