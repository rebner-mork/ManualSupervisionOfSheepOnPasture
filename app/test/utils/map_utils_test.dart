import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';
import 'package:app/utils/map_utils.dart';

void main() {
  group("Map utils unit tests:", () {
    test('Get device position marker', () async {
      var pos = LatLng(61.123, 6.123);
      expect(getDevicePositionMarker(pos).point, pos);
    });

    test('Convert latitude and longitude to tile indexes', () {
      // Far north - King Oscar 2's Chapell
      expect(153508, getTileIndexX(30.811433, 18));
      expect(59123, getTileIndexY(69.784858, 18));

      // Far south - Lindesnes Lighthouse
      expect(68101, getTileIndexX(7.047648, 17));
      expect(39489, getTileIndexY(57.982383, 17));

      // In the middle of the map - Studentersamfundet
      expect(34660, getTileIndexX(10.395004, 16));
      expect(17715, getTileIndexY(63.422493, 16));

      // Zoomed all the way out - Norway
      expect(0, getTileIndexX(6.151630, 0));
      expect(0, getTileIndexY(62.470818, 0));

      // Unaccurate coordinates - Norway
      expect(135550, getTileIndexX(6.15, 18));
      expect(72386, getTileIndexY(62.47, 18));
    });
  });
}
