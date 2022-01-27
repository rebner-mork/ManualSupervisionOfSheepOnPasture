import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'dart:developer';

import 'map_utils.dart' as map_utils;

class NorgesKart extends StatefulWidget {
  const NorgesKart({Key? key}) : super(key: key);

  @override
  State<NorgesKart> createState() => _NorgesKartState();
}

class _NorgesKartState extends State<NorgesKart> {
  final String mapType = 'topo4';
  MapController _mapController = MapController();

  Future<void> _setPosition() async {
    var pos = await map_utils.getDevicePosition();
    log(pos.toString());
    setState(() {
      _mapController.move(pos, 13);
    });
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
          zoom: 13.0,
          // TODO fin max and min zoom levels
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
        ],
      ),
    );
  }
}
