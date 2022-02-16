@Timeout(Duration(seconds: 180))
import 'dart:developer';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';

import 'package:app/utils/map_utils.dart';
import 'package:path_provider/path_provider.dart';

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

      // Unacurate coordinates - Norway
      expect(135550, getTileIndexX(6.15, 18));
      expect(72386, getTileIndexY(62.47, 18));
    });
    test("Download tiles to app document directory", () async {
      List<String> acutalDirectoryListing = [];
      List<String> expectedDirectoryListing = [];
      LatLng northWest = LatLng(63.419818, 10.397676);
      LatLng southEast = LatLng(63.415958, 10.408697);
      int minZoom = 15;
      int maxZoom = 16;
      Directory baseDir = await getApplicationDocumentsDirectory();
      String basePath = baseDir.path + "/maps";

      try {
        Directory(basePath).deleteSync(recursive: true);
      } on FileSystemException {
        log("Could not find directory, probably doesn't exist");
      } catch (_) {
        rethrow;
      }

      //Construct expected directory listing
      for (int zoom = minZoom; zoom <= maxZoom; zoom++) {
        int west = getTileIndexX(northWest.longitude, zoom);
        int east = getTileIndexX(southEast.longitude, zoom);
        //-1 to compesate for rounding down when calculating tile indeces
        int north = getTileIndexY(northWest.latitude, zoom) - 1;
        int south = getTileIndexY(southEast.latitude, zoom);
        String currentPath = basePath + "/" + zoom.toString();
        expectedDirectoryListing.add(currentPath);
        for (int x = west; x <= east; x++) {
          expectedDirectoryListing.add(currentPath + "/" + x.toString());
          for (int y = north; y <= south; y++) {
            expectedDirectoryListing.add(
                currentPath + "/" + x.toString() + "/" + y.toString() + ".png");
          }
        }
      }

      await downlaodTiles(northWest, southEast, minZoom, maxZoom);

      Directory mapDir = Directory(basePath);
      await for (var entity
          in mapDir.list(recursive: true, followLinks: false)) {
        acutalDirectoryListing.add(entity.path);
      }

      expect(acutalDirectoryListing.length, expectedDirectoryListing.length);

      Set<String> expectedDirectoryListingSet =
          expectedDirectoryListing.toSet();

      expect(acutalDirectoryListing.length, expectedDirectoryListingSet.length);

      for (var path in acutalDirectoryListing) {
        expect(true, expectedDirectoryListingSet.contains(path));
      }

      int oldLenght = acutalDirectoryListing.length;

      await downlaodTiles(northWest, southEast, minZoom, maxZoom);

      acutalDirectoryListing = [];
      await for (var entity
          in mapDir.list(recursive: true, followLinks: false)) {
        acutalDirectoryListing.add(entity.path);
      }

      expect(oldLenght, acutalDirectoryListing.length);

      Directory(basePath).deleteSync(recursive: true);
    });
  });
}
