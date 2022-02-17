import 'package:app/utils/speech_input_filters.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('correctErroneousInput', () {
    test('Valid input', () {
      expect(correctErroneousInput('0', QuestionContext.numbers), '');
      expect(correctErroneousInput('white', QuestionContext.colors), '');
      expect(correctErroneousInput('black', QuestionContext.colors), '');
    });

    test('Erroneous number input is corrected', () {
      expect(correctErroneousInput('zero', QuestionContext.numbers), '0');
      expect(correctErroneousInput('five', QuestionContext.numbers), '5');
      expect(correctErroneousInput('see row', QuestionContext.numbers), '0');
      expect(correctErroneousInput('hive', QuestionContext.numbers), '5');
    });

    test('Erroneous color input is corrected', () {
      expect(correctErroneousInput('what', QuestionContext.colors), 'white');
      expect(correctErroneousInput('mellow', QuestionContext.colors), 'yellow');
    });

    test('Words not in filters return ', () {
      expect(correctErroneousInput('random', QuestionContext.colors), '');
      expect(correctErroneousInput('random', QuestionContext.numbers), '');
    });
  });
}
