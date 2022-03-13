import 'package:flutter_test/flutter_test.dart';
import 'package:web/utils/constants.dart';

void main() {
  test('possibleEartagColors and possibleEartagKeys are same length', () {
    expect(possibleEartagColors.length, possibleEartagKeys.length);
  });
}
