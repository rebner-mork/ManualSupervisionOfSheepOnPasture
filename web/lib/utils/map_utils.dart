import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'dart:math';

import 'package:web/trips/detailed/registration_details/registration_details.dart';

abstract class MapProvider {
  static const String urlTemplate =
      "https://opencache{s}.statkart.no/gatekeeper/gk/gk.open_gmaps?layers=topo4&zoom={z}&x={x}&y={y}";
  static final List<String> subdomains = ['', '2', '3'];
}

Marker getMarker(Map<String, dynamic> registration) {
  const double size = 50;

  final AssetImage image;

  switch (registration['type']) {
    case 'injuredSheep':
      image = const AssetImage('images/sheep_marker_injury.png');
      break;
    case 'cadaver':
      image = const AssetImage('images/sheep_marker_cadaver.png');
      break;
    case 'predator':
      image = const AssetImage('images/predator_wolf_marker.png');
      break;
    case 'note':
      image = const AssetImage('images/note_marker.png');
      break;
    default:
      image = const AssetImage('images/sheep_marker_green.png');
      break;
  }

  return Marker(
      point: LatLng(registration['registrationPosition']['latitude']! as double,
          registration['registrationPosition']['longitude']! as double),
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

Marker getCornerMarker({required LatLng position, required bool upperLeft}) {
  const double size = 50;
  return Marker(
      point: position,
      height: size,
      width: size,
      builder: (context) => Transform.rotate(
          angle: 45 * pi / 180,
          child: Icon(
            upperLeft ? Icons.chevron_right : Icons.chevron_left,
            color: Colors.pink,
            size: size,
          )));
}

NetworkImage getMapNetworkImage(
    {required LatLng northWest, required LatLng southEast, required int zoom}) {
  LatLng centerPoint = LatLngBounds(
          LatLng(southEast.latitude, northWest.longitude),
          LatLng(northWest.latitude, southEast.longitude))
      .center;
  int x = getTileIndexX(longitude: centerPoint.longitude, zoom: zoom);
  int y = getTileIndexY(latitude: centerPoint.latitude, zoom: zoom);

  return NetworkImage(_getTileUrl(x: x, y: y, zoom: zoom), scale: 2);
}

String _getTileUrl({required int x, required int y, required int zoom}) {
  var random = Random();
  return MapProvider.urlTemplate
      .replaceFirst("{z}", zoom.toString())
      .replaceFirst("{x}", x.toString())
      .replaceFirst("{y}", y.toString())
      .replaceFirst(
          "{s}",
          MapProvider
              .subdomains[random.nextInt(MapProvider.subdomains.length)]);
}

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
