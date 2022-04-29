import 'dart:math';
import 'dart:io';
import 'package:app/registration_details/registration_details.dart';
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
      return Future.error('Location services is not enabled');
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

// --- MARKERS AND LINES ---

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

Marker getMapMarker(
    {required Map<String, dynamic> registration,
    required LatLng position,
    required RegistrationType type,
    SheepMarkerColor color = SheepMarkerColor.green}) {
  const double size = 50;
  final AssetImage image;

  switch (type) {
    case RegistrationType.sheep:
      switch (color) {
        case SheepMarkerColor.green:
          image = const AssetImage('images/sheep_marker_green.png');
          break;
        case SheepMarkerColor.yellow:
          image = const AssetImage('images/sheep_marker_yellow.png');
          break;
        case SheepMarkerColor.red:
          image = const AssetImage('images/sheep_marker_red.png');
          break;
      }
      break;
    case RegistrationType.injury:
      image = const AssetImage('images/sheep_marker_injury.png');
      break;
    case RegistrationType.cadaver:
      image = const AssetImage('images/sheep_marker_cadaver.png');
      break;
    case RegistrationType.predator:
      image = const AssetImage('images/predator_wolf_marker.png');
      break;
    case RegistrationType.note:
      image = const AssetImage('images/note_marker.png');
      break;
    default:
      image = const AssetImage('images/sheep_marker_green.png');
      break;
  }

  return Marker(
      point: position,
      anchorPos: AnchorPos.align(AnchorAlign.top),
      rotateAlignment: Alignment.bottomCenter,
      height: size,
      width: size,
      rotate: true,
      builder: (context) => GestureDetector(
          onTap: () => showDialog(
              context: context,
              builder: (context) =>
                  RegistrationDetails(registration: registration)),
          child: Image(
            image: image,
            width: size,
            height: size,
            filterQuality: FilterQuality.medium,
          )));
}

Polyline getLineOfSight(List<LatLng> points) {
  return Polyline(
      points: points, color: Colors.black, isDotted: true, strokeWidth: 5.0);
}

// --- INDEX CALCULATIONS ---

int getTileIndexX({required double longitude, required int zoom}) {
  return (((longitude + 180) / 360) * pow(2, zoom)).floor();
}

int getTileIndexY({required double latitude, required int zoom}) {
  var latitudeInRadians = latitude * (pi / 180);
  return ((1 -
              ((log(tan(latitudeInRadians) + (1 / cos(latitudeInRadians)))) /
                  pi)) *
          pow(2, zoom - 1))
      .floor();
}

int numberOfTiles(
    {required LatLng northWest,
    required LatLng southEast,
    required double minZoom,
    required double maxZoom}) {
  int _numberOfTiles = 0;
  for (int zoom = minZoom.toInt(); zoom <= maxZoom.toInt(); zoom++) {
    int west = getTileIndexX(longitude: northWest.longitude, zoom: zoom);
    int east = getTileIndexX(longitude: southEast.longitude, zoom: zoom);
    int north = getTileIndexY(latitude: northWest.latitude, zoom: zoom);
    int south = getTileIndexY(latitude: southEast.latitude, zoom: zoom);

    _numberOfTiles += (east - west + 1) * (south - north + 1);
  }
  return _numberOfTiles;
}

// --- PATHS ---

String _getTileUrl(
    {required String urlTemplate,
    required int x,
    required int y,
    required int zoom,
    required List<String> subdomains}) {
  var random = Random();
  return urlTemplate
      .replaceFirst("{z}", zoom.toString())
      .replaceFirst("{x}", x.toString())
      .replaceFirst("{y}", y.toString())
      .replaceFirst("{s}", subdomains[random.nextInt(subdomains.length)]);
}

String getLocalUrlTemplate() {
  return applicationDocumentDirectoryPath + "/maps/{z}/{x}/{y}.png";
}

String _getLocalTileUrl({required int x, required int y, required int z}) {
  return _getTileUrl(
      urlTemplate: getLocalUrlTemplate(),
      x: x,
      y: y,
      zoom: z,
      subdomains: [""]);
}

String _getServerTileUrl({required int x, required int y, required int z}) {
  return _getTileUrl(
      urlTemplate: MapProvider.urlTemplate,
      x: x,
      y: y,
      zoom: z,
      subdomains: MapProvider.subdomains);
}

// --- DOWNLOADS ---

Future<void> _downloadTile(
    {required int x, required int y, required int zoom}) async {
  String localFilePath = _getLocalTileUrl(x: x, y: y, z: zoom);
  String localDirPath = localFilePath.replaceAll(y.toString() + ".png", "");

  if (!File(localFilePath).existsSync()) {
    await Directory(localDirPath).create(recursive: true);
    var response =
        await http.get(Uri.parse(_getServerTileUrl(x: x, y: y, z: zoom)));
    File(localFilePath).writeAsBytesSync(response.bodyBytes);
  }
}

Future<void> downloadTiles(
    {required LatLng northWest,
    required LatLng southEast,
    required double minZoom,
    required double maxZoom,
    ValueChanged<double>? progressIndicator}) async {
  int currentTileNumber = 0;
  int totalTileNumber = numberOfTiles(
      northWest: northWest,
      southEast: southEast,
      minZoom: minZoom,
      maxZoom: maxZoom);

  for (int zoom = minZoom.toInt(); zoom <= maxZoom.toInt(); zoom++) {
    int west = getTileIndexX(longitude: northWest.longitude, zoom: zoom);
    int east = getTileIndexX(longitude: southEast.longitude, zoom: zoom);
    int north = getTileIndexY(latitude: northWest.latitude, zoom: zoom);
    int south = getTileIndexY(latitude: southEast.latitude, zoom: zoom);

    for (int x = west; x <= east; x++) {
      for (int y = north; y <= south; y++) {
        await _downloadTile(x: x, y: y, zoom: zoom);
        if (progressIndicator != null) {
          progressIndicator(++currentTileNumber / totalTileNumber);
        }
      }
    }
  }
}

bool isEveryTileDownloaded(
    {required LatLng northWest,
    required LatLng southEast,
    required double minZoom,
    required double maxZoom}) {
  for (int zoom = minZoom.toInt(); zoom <= maxZoom.toInt(); zoom++) {
    int west = getTileIndexX(longitude: northWest.longitude, zoom: zoom);
    int east = getTileIndexX(longitude: southEast.longitude, zoom: zoom);
    int north = getTileIndexY(latitude: northWest.latitude, zoom: zoom);
    int south = getTileIndexY(latitude: southEast.latitude, zoom: zoom);

    for (int x = west; x <= east; x++) {
      for (int y = north; y <= south; y++) {
        String path = _getLocalTileUrl(x: x, y: y, z: zoom);
        if (!File(path).existsSync()) {
          return false;
        }
      }
    }
  }
  return true;
}
