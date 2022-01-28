import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'dart:async';

import 'map_utils.dart' as map_utils;

class NorgesKart extends StatefulWidget {
  const NorgesKart({Key? key}) : super(key: key);

  static const String route = 'map';

  @override
  State<NorgesKart> createState() => _NorgesKartState();
}

class _NorgesKartState extends State<NorgesKart> {
  final String mapType = 'topo4';
  MapController _mapController = MapController();
  Marker _currentPositionMarker =
      map_utils.getDevicePositionMarker(LatLng(0, 0));
  Timer? timer;

  Future<void> _setPosition() async {
    LatLng pos = await map_utils.getDevicePosition();
    setState(() {
      _mapController.move(pos, 18);
      _currentPositionMarker = map_utils.getDevicePositionMarker(pos);
    });
  }

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(
        const Duration(seconds: 15), (Timer t) => _setPosition());
  }

  @override
  void dispose() {
    timer?.cancel();
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
            _setPosition();
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
        ],
      ),
    );
  }
}
