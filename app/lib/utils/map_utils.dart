import 'dart:math';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/flutter_map.dart';

Future<LatLng> getDevicePosition() async {
  LocationData _locationData;
  Location location = Location();

  bool _serviceEnabled;
  PermissionStatus _permissionGranted;

  _serviceEnabled = await location.serviceEnabled();
  if (!_serviceEnabled) {
    _serviceEnabled = await location.requestService();
    if (!_serviceEnabled) {
      return Future.error('Location services is not enabeled');
    }
  }

  _permissionGranted = await location.hasPermission();
  if (_permissionGranted == PermissionStatus.denied) {
    _permissionGranted = await location.requestPermission();
    if (_permissionGranted != PermissionStatus.granted) {
      return Future.error('Location services does not have permissions');
    }
  }

  _locationData = await location.getLocation();

  return LatLng(_locationData.latitude!, _locationData.longitude!);
}

Marker getDevicePositionMarker(LatLng pos) {
  const double size = 40;
  return Marker(
      point: pos,
      height: size,
      width: size,
      builder: (context) => const Icon(
            Icons.gps_fixed,
            color: Colors.pink,
            size: size,
          ));
}

int _xTileIndex(double longitude, int zoom) {
  return (((longitude + 180) / 360) * pow(2, zoom)).floor();
}

int _yTileIndex(double latitude, int zoom) {
  var latitudeInRadians = latitude * (pi / 180);
  var y = ((1 -
              ((log(tan(latitudeInRadians) + (1 / cos(latitudeInRadians)))) /
                  pi)) *
          pow(2, zoom - 1))
      .floor();
  return y;
}

//TODO brukes bare av testene
Point getTileIndexes(double latitude, double longitude, int zoom) {
  return Point(_xTileIndex(longitude, zoom), _yTileIndex(latitude, zoom));
}

String _getTileUrl(String urlTemplate, int x, int y, int zoom) {
  return urlTemplate
      .replaceFirst("{z}", zoom.toString())
      .replaceFirst("{x}", x.toString())
      .replaceFirst("{y}", y.toString());
}

Future<void> _downloadTile(int x, int y, int z, String urlTemplate) async {
  Directory baseDir = await getApplicationSupportDirectory();
  String basePath = baseDir.path;
  String subPath = "/maps/" + z.toString() + "/" + x.toString();
  await Directory(basePath + subPath).create(recursive: true);
  String fileName = "/" + y.toString() + ".png";
  var response = await http.get(Uri.parse(_getTileUrl(urlTemplate, x, y, z)));
  File(basePath + subPath + fileName).writeAsBytesSync(response.bodyBytes);
}

// TODO ikke returnere future siden den bare skal suse i bakgrunnen???????????
Future<void> downlaodTiles(
    String urlTemplate, Point northWest, Point southEast, int zoom) async {
  //TODO legge inn listeparameter for zoom slik at man kan ta mange tiles i en smekk
  //TODO legge inn variasjon på subdomener

  int west = _xTileIndex(northWest.y.toDouble(), zoom);
  int east = _xTileIndex(southEast.y.toDouble(), zoom);
  int north = _yTileIndex(northWest.x.toDouble(), zoom);
  int south = _yTileIndex(southEast.x.toDouble(), zoom);

  for (int x = west; x <= east; x++) {
    for (int y = north; y <= south; y++) {
      await _downloadTile(x, y, zoom, urlTemplate);
    }
  }
}