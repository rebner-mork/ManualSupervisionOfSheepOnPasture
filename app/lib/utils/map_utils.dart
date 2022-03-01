import 'dart:math';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:latlong2/latlong.dart';

import 'package:flutter_map/flutter_map.dart';

// --- LOCATION SERVICE ---

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

// --- MARKERS ---

Marker getDevicePositionMarker(LatLng pos) {
  const double size = 40;
  return Marker(
      point: pos,
      height: size,
      width: size,
      builder: (context) => const Icon(
            Icons.gps_fixed,
            color: Colors.red,
            size: size,
          ));
}

Marker getSheepMarker(LatLng pos) {
  const double size = 50;
  return Marker(
      point: pos,
      anchorPos: AnchorPos.align(AnchorAlign.top),
      rotateAlignment: Alignment.bottomCenter,
      height: size,
      width: size,
      rotate: true,
      builder: (context) => const Image(
            image: AssetImage("images/sheep_marker_green.png"),
            width: size,
            height: size,
          ));
}

// --- INDEX CALCULATIONS ---

int getTileIndexX(double longitude, int zoom) {
  return (((longitude + 180) / 360) * pow(2, zoom)).floor();
}

int getTileIndexY(double latitude, int zoom) {
  var latitudeInRadians = latitude * (pi / 180);
  return ((1 -
              ((log(tan(latitudeInRadians) + (1 / cos(latitudeInRadians)))) /
                  pi)) *
          pow(2, zoom - 1))
      .floor();
}

// --- PATHS ---

String _getTileUrl(
    String urlTemplate, int x, int y, int zoom, List<String> subdomains) {
  var random = Random();
  return urlTemplate
      .replaceFirst("{z}", zoom.toString())
      .replaceFirst("{x}", x.toString())
      .replaceFirst("{y}", y.toString())
      .replaceFirst("{s}", subdomains[random.nextInt(subdomains.length)]);
}

Future<String> getLocalUrlTemplate() async {
  Directory baseDir = await getApplicationDocumentsDirectory();
  return baseDir.path + "/maps/{z}/{x}/{y}.png";
}

Future<String> _getLocalTileUrl(int x, int y, int z) async {
  String urlTemplate = await getLocalUrlTemplate();
  return _getTileUrl(urlTemplate, x, y, z, [""]);
}

// --- DOWNLOADS ---

Future<void> _downloadTile(
    int x, int y, int zoom, String urlTemplate, List<String> subdomains) async {
  Directory baseDir = await getApplicationDocumentsDirectory();
  String basePath = baseDir.path;
  String subPath = "/maps/" + zoom.toString() + "/" + x.toString();
  await Directory(basePath + subPath).create(recursive: true);
  String fileName = "/" + y.toString() + ".png";

  if (!File(basePath + subPath + fileName).existsSync()) {
    var response = await http
        .get(Uri.parse(_getTileUrl(urlTemplate, x, y, zoom, subdomains)));
    File(basePath + subPath + fileName).writeAsBytesSync(response.bodyBytes);
  }
}

// TODO Should this return Future<void> or just void ???
Future<void> downloadTiles(
    LatLng northWest, LatLng southEast, double minZoom, double maxZoom) async {
  String urlTemplate =
      "https://opencache{s}.statkart.no/gatekeeper/gk/gk.open_gmaps?layers=topo4&zoom={z}&x={x}&y={y}";
  final List<String> subdomains = ["", "2", "3"];

  for (int zoom = minZoom.toInt(); zoom <= maxZoom.toInt(); zoom++) {
    int west = getTileIndexX(northWest.longitude, zoom);
    int east = getTileIndexX(southEast.longitude, zoom);
    int north = getTileIndexY(northWest.latitude, zoom);
    int south = getTileIndexY(southEast.latitude, zoom);

    for (int x = west; x <= east; x++) {
      for (int y = north; y <= south; y++) {
        await _downloadTile(x, y, zoom, urlTemplate, subdomains);
      }
    }
  }
}

Future<bool> isTilesDownloaded(
    LatLng northWest, LatLng southEast, double minZoom, double maxZoom) async {
  for (int zoom = minZoom.toInt(); zoom <= maxZoom.toInt(); zoom++) {
    int west = getTileIndexX(northWest.longitude, zoom);
    int east = getTileIndexX(southEast.longitude, zoom);
    int north = getTileIndexY(northWest.latitude, zoom);
    int south = getTileIndexY(southEast.latitude, zoom);

    for (int x = west; x <= east; x++) {
      for (int y = north; y <= south; y++) {
        String path = await _getLocalTileUrl(x, y, zoom);
        if (!File(path).existsSync()) {
          return false;
        }
      }
    }
  }
  return true;
}
