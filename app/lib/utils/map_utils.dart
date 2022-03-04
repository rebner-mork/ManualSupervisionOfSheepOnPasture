import 'dart:math';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:latlong2/latlong.dart';

import 'package:flutter_map/flutter_map.dart';
import 'constants.dart';

// --- MAP PROVIDER ---

abstract class MapProvider {
  static const String urlTemplate =
      "https://opencache{s}.statkart.no/gatekeeper/gk/gk.open_gmaps?layers=topo4&zoom={z}&x={x}&y={y}";
  static final List<String> subdomains = ["", "2", "3"];
}

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

//TODO REFACTOR with calculations!!!!!!!!!!
int numberOfTiles(
    LatLng northWest, LatLng southEast, double minZoom, double maxZoom) {
  int _numberOfTiles = 0;
  for (int zoom = minZoom.toInt(); zoom <= maxZoom.toInt(); zoom++) {
    int west = getTileIndexX(northWest.longitude, zoom);
    int east = getTileIndexX(southEast.longitude, zoom);
    int north = getTileIndexY(northWest.latitude, zoom);
    int south = getTileIndexY(southEast.latitude, zoom);

    _numberOfTiles += (east - west + 1) * (south - north + 1);
  }
  return _numberOfTiles;
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

String getLocalUrlTemplate() {
  return APPLICATION_DOCUMENT_DIRECTORY_PATH + "/maps/{z}/{x}/{y}.png";
}

String _getLocalTileUrl(int x, int y, int z) {
  return _getTileUrl(getLocalUrlTemplate(), x, y, z, [""]);
}

String _getServerTileUrl(int x, int y, int z) {
  return _getTileUrl(MapProvider.urlTemplate, x, y, z, MapProvider.subdomains);
}

// --- DOWNLOADS ---

Future<void> _downloadTile(int x, int y, int zoom) async {
  String localFilePath = _getLocalTileUrl(x, y, zoom);
  String localDirPath = localFilePath.replaceAll(y.toString() + ".png", "");

  if (!File(localFilePath).existsSync()) {
    await Directory(localDirPath).create(recursive: true);
    var response = await http.get(Uri.parse(_getServerTileUrl(x, y, zoom)));
    File(localFilePath).writeAsBytesSync(response.bodyBytes);
  }
}

Future<void> downloadTiles(
    LatLng northWest, LatLng southEast, double minZoom, double maxZoom,
    {ValueChanged<double>? progressIndicator}) async {
  int currentTileNumber = 0;
  int totalTileNumber = numberOfTiles(northWest, southEast, minZoom, maxZoom);

  for (int zoom = minZoom.toInt(); zoom <= maxZoom.toInt(); zoom++) {
    int west = getTileIndexX(northWest.longitude, zoom);
    int east = getTileIndexX(southEast.longitude, zoom);
    int north = getTileIndexY(northWest.latitude, zoom);
    int south = getTileIndexY(southEast.latitude, zoom);

    for (int x = west; x <= east; x++) {
      for (int y = north; y <= south; y++) {
        await _downloadTile(x, y, zoom);
        if (progressIndicator != null) {
          progressIndicator(++currentTileNumber / totalTileNumber);
        }
      }
    }
  }
}

bool isTilesDownloaded(
    LatLng northWest, LatLng southEast, double minZoom, double maxZoom) {
  for (int zoom = minZoom.toInt(); zoom <= maxZoom.toInt(); zoom++) {
    int west = getTileIndexX(northWest.longitude, zoom);
    int east = getTileIndexX(southEast.longitude, zoom);
    int north = getTileIndexY(northWest.latitude, zoom);
    int south = getTileIndexY(southEast.latitude, zoom);

    for (int x = west; x <= east; x++) {
      for (int y = north; y <= south; y++) {
        String path = _getLocalTileUrl(x, y, zoom);
        if (!File(path).existsSync()) {
          return false;
        }
      }
    }
  }
  return true;
}
