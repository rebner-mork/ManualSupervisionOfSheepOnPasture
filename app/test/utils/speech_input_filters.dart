import 'package:app/utils/speech_input_filters.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('correctErroneousInput', () {
    test('Valid input', () {
      expect(
          correctErroneousInput(
              input: '0', questionContext: QuestionContext.numbers),
          '');
      expect(
          correctErroneousInput(
              input: 'white', questionContext: QuestionContext.colors),
          '');
      expect(
          correctErroneousInput(
              input: 'black', questionContext: QuestionContext.colors),
          '');
    });

    test('Erroneous number input is corrected', () {
      expect(
          correctErroneousInput(
              input: 'zero', questionContext: QuestionContext.numbers),
          '0');
      expect(
          correctErroneousInput(
              input: 'five', questionContext: QuestionContext.numbers),
          '5');
      expect(
          correctErroneousInput(
              input: 'see row', questionContext: QuestionContext.numbers),
          '0');
      expect(
          correctErroneousInput(
              input: 'hive', questionContext: QuestionContext.numbers),
          '5');
    });

    test('Erroneous color input is corrected', () {
      expect(
          correctErroneousInput(
              input: 'what', questionContext: QuestionContext.colors),
          'white');
      expect(
          correctErroneousInput(
              input: 'mellow', questionContext: QuestionContext.colors),
          'yellow');
    });

    test('Words not in filters return ', () {
      expect(
          correctErroneousInput(
              input: 'random', questionContext: QuestionContext.colors),
          '');
      expect(
          correctErroneousInput(
              input: 'random', questionContext: QuestionContext.numbers),
          '');
    });
  });
}
