enum QuestionContext { numbers, colors }

String correctErroneousInput(
    {required String input, required QuestionContext questionContext}) {
  String correctedInput = '';

  input = input.toLowerCase();

  if (questionContext == QuestionContext.numbers) {
    for (MapEntry<String, List<String>> numberFilter in numbersFilter.entries) {
      if (numberFilter.value.contains(input)) {
        correctedInput = numberFilter.key;
        break;
      }
    }
  } else {
    for (MapEntry<String, List<String>?> colorFilter in colorsFilter.entries) {
      if (colorFilter.value!.contains(input)) {
        correctedInput = colorFilter.key;
        break;
      }
    }
  }

  return correctedInput;
}

final Map<String, List<String>> numbersFilter = {
  '0': [
    'zero',
    'see row',
    'sierra',
    'siri',
    'null',
    'co',
    'euro',
    'see you though',
    'hero',
    'see road',
    'sarah'
  ],
  '1': ['one', 'won', 'want', 'who won', 'on', 'what', 'when', 'won\'t'],
  '2': ['two', 'too', 'to', 'to you', 'do'],
  '3': ['three', 'treat', 'tree', 'the'],
  '4': ['four', 'for', 'or', 'ford', 'full'],
  '5': ['five', 'hive', 'i\'ve', 'pipe'],
  '6': ['six', 'sex', 'sick', 'thanks', 'seats'],
  '7': ['seven', 'satin'],
  '8': ['eight', 'ate', 'aight', 'hate', 'hey'],
  '9': ['nine', 'mine', 'line', 'night'],
  '10': ['ten', 'time', 'tom', 'turn', 'and', 'pam', 'done', 'them'],
  '11': ['eleven', 'i love them'],
  '12': ['twelve', 'tyler', 'corral', 'to health']
};

final Map<String, List<String>?> colorsFilter = {
  'white': ['what', 'light', 'whites'],
  'black': ['lack', 'block', 'blacks'],
  'red': [
    'rent',
    'rat',
    'rad',
    'brad',
    'brat',
    'rod',
    'and',
    'rap',
    'rob',
    'ribs',
    'ready'
  ],
  'yellow': ['mellow', 'yeah love'],
  'blue': ['glue', 'boo', 'play', 'flute', 'bleed', 'lou', 'luke'],
  'green': ['great', 'when'],
  'purple': null, // TODO: test
  'pink': null, // TODO: test
  'grey': null, // TODO: test
  'orange': null // TODO: test
};
