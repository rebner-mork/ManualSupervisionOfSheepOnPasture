import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'dart:math' as math;

Marker getCornerMarker(LatLng pos, bool upperLeft) {
  const double size = 50;
  return Marker(
      point: pos,
      height: size,
      width: size,
      builder: (context) => Transform.rotate(
          angle: 45 * math.pi / 180,
          child: Icon(
            upperLeft ? Icons.chevron_right : Icons.chevron_left,
            color: Colors.pink,
            size: size,
          )));
}
