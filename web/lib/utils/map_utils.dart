import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'dart:math';

import 'package:web/trips/detailed/registration_details.dart';

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
      image = const AssetImage('images/predator_marker.png');
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

Marker getCornerMarker(LatLng pos, bool upperLeft) {
  const double size = 50;
  return Marker(
      point: pos,
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

NetworkImage getMapNetworkImage(LatLng northWest, LatLng southEast, int zoom) {
  LatLng centerPoint = LatLngBounds(
          LatLng(southEast.latitude, northWest.longitude),
          LatLng(northWest.latitude, southEast.longitude))
      .center;
  int x = getTileIndexX(centerPoint.longitude, zoom);
  int y = getTileIndexY(centerPoint.latitude, zoom);

  return NetworkImage(_getTileUrl(x, y, zoom), scale: 2);
}

String _getTileUrl(int x, int y, int zoom) {
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
