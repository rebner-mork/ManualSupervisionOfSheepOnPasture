import 'package:app/utils/speech_input_filters.dart';

Map<String, Map<String, QuestionContext>> sheepQuestions = {
  'distance': {
    'Hvor mange sauer?': QuestionContext.numbers,
    'Hvor mange lam?': QuestionContext.numbers,
    'Hvor mange hvite?': QuestionContext.numbers,
    'Hvor mange svarte?': QuestionContext.numbers,
    'Hvor mange med svart hode?': QuestionContext.numbers,
  },
  'close': {
    'Hvor mange røde slips?': QuestionContext.numbers,
    'Hvor mange blå slips?': QuestionContext.numbers,
    'Hvor mange gule slips?': QuestionContext.numbers,
    'Hvor mange røde øremerker?': QuestionContext.numbers,
    'Hvor mange blå øremerker?': QuestionContext.numbers
  }
};
