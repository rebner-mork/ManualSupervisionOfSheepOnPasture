enum QuestionContext { numbers, colors }

// TODO: support "previous"
String correctErroneousInput(String input, QuestionContext questionContext) {
  String correctedInput = '';

  input = input.toLowerCase();

  if (questionContext == QuestionContext.numbers) {
    for (List<String> numberFilter in numbersFilter) {
      if (numberFilter.contains(input)) {
        int index = numbersFilter.indexOf(numberFilter);
        correctedInput = numbers[index];
        break;
      }
    }
  } else {
    for (List<String> colorFilter in colorsFilter) {
      if (colorFilter.contains(input)) {
        int index = colorsFilter.indexOf(colorFilter);
        correctedInput = colors[index];
      }
    }
  }

  return (correctedInput == '') ? input : correctedInput;
}

final List<String> numbers = [
  '0',
  '1',
  '2',
  '3',
  '4',
  '5',
  '6',
  '7',
  '8',
  '9',
  '10',
  '11',
  '12'
];

final List<List<String>> numbersFilter = [
  [
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
  ['one', 'won', 'want', 'who won', 'on', 'what', 'when', 'won\'t'],
  ['two', 'too', 'to', 'to you', 'do'],
  ['three', 'treat', 'tree', 'the'],
  ['four', 'for', 'or', 'ford', 'full'],
  ['five', 'hive', 'i\'ve', 'pipe'],
  ['six', 'sex', 'sick', 'thanks', 'seats'],
  ['seven', 'satin'],
  ['eight', 'ate', 'aight', 'hate', 'hey'],
  ['nine', 'mine', 'line', 'night'],
  ['ten', 'time', 'tom', 'turn', 'and', 'pam', 'done', 'them'],
  ['eleven', 'i love them'],
  ['twelve', 'tyler', 'corral', 'to health'],
];

final List<String> colors = [
  'white',
  'black',
  'red',
  'yellow',
  'blue',
  'green',
  'purple',
  'pink',
  'grey',
  'orange'
];

final List<List<String>> colorsFilter = [
  ['what', 'light', 'whites'],
  ['lack', 'block', 'black', 'blacks'],
  [
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
  ['mellow', 'yeah love'],
  ['glue', 'boo', 'play', 'flute', 'bleed', 'lou', 'luke'],
  ['great', 'when'],
];
