import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/flutter_map.dart';

import 'package:app/utils/map_utils.dart';

void main() {
  group("Unit tests for map utils", () {
    test('Get device position marker', () async {
      var pos = LatLng(61.123, 6.123);
      var marker = getDevicePositionMarker(pos);
      expect(marker is Marker, true);
      expect(marker.point, pos);
    });
  });
}
