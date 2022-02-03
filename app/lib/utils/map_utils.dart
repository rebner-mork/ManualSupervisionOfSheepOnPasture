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
