import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';

import 'package:app/utils/map_utils.dart';

void main() {
  group("Map utils unit tests", () {
    test('Get device position marker', () async {
      var pos = LatLng(61.123, 6.123);
      expect(getDevicePositionMarker(pos).point, pos);
    });

    test('Convert latitude and longitude to tile indexes', () {
      // Far north
      var kingOscarTheSecondsChapell = getTileIndexes(69.784858, 30.811433, 18);
      expect(153508, kingOscarTheSecondsChapell.x);
      expect(59123, kingOscarTheSecondsChapell.y);

      // Far south
      var lindesnesLighthouse = getTileIndexes(57.982383, 7.047648, 17);
      expect(68101, lindesnesLighthouse.x);
      expect(39489, lindesnesLighthouse.y);

      // In the middle of the map
      var samfundet = getTileIndexes(63.422493, 10.395004, 16);
      expect(34660, samfundet.x);
      expect(17715, samfundet.y);

      // Zoomed all the way out
      var norway = getTileIndexes(62.470818, 6.151630, 0);
      expect(0, norway.x);
      expect(0, norway.y);

      // Unacurate coordinates
      norway = getTileIndexes(62.47, 6.15, 18);
      expect(135550, norway.x);
      expect(72386, norway.y);
    });
  });
}
