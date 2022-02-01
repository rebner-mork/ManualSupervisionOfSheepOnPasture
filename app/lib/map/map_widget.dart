import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'dart:async';

import '../utils/map_utils.dart' as map_utils;

class Map extends StatefulWidget {
  const Map({Key? key}) : super(key: key);

  static const String route = 'map';

  @override
  State<Map> createState() => _MapState();
}

class _MapState extends State<Map> {
  final String mapType = 'topo4';
  MapController _mapController = MapController();
  Marker _currentPositionMarker =
      map_utils.getDevicePositionMarker(LatLng(0, 0));
  late Timer timer;
  final List<LatLng> _movementPoints = [];

  Future<void> _updateMap() async {
    LatLng pos = await map_utils.getDevicePosition();
    setState(() {
      _mapController.move(pos, _mapController.zoom);
      _currentPositionMarker = map_utils.getDevicePositionMarker(pos);
      _movementPoints.add(pos);
    });
  }

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(seconds: 15), (_) => _updateMap());
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: FlutterMap(
        mapController: _mapController,
        options: MapOptions(
          onMapCreated: (c) {
            _mapController = c;
            _updateMap();
          },
          minZoom: 5,
          maxZoom: 18,
        ),
        layers: [
          TileLayerOptions(
            urlTemplate:
                "https://opencache{s}.statkart.no/gatekeeper/gk/gk.open_gmaps?layers=$mapType&zoom={z}&x={x}&y={y}",
            subdomains: ['', '2', '3'],
            attributionBuilder: (_) {
              return const Text(
                "Kartverket",
                style: TextStyle(color: Colors.black, fontSize: 20),
              );
            },
          ),
          MarkerLayerOptions(markers: [_currentPositionMarker], rotate: true),
          PolylineLayerOptions(polylines: [
            Polyline(
                points: _movementPoints,
                color: Colors.red,
                isDotted: true,
                strokeWidth: 10.0)
          ])
        ],
      ),
    );
  }
}
