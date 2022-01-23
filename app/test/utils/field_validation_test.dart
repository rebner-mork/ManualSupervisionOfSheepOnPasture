import 'package:app/utils/field_validation.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Unit tests for field validation', () {
    test('Validate phone', () {
      expect(validatePhone(''), 'Skriv telefonnummer');
      expect(validatePhone('1'), 'Telefonnummer må inneholde minst 8 siffer');
      expect(validatePhone('a'), 'Telefonnummer må kun bestå av siffer');
      expect(validatePhone('12345678'), null);
    });
  });
}
