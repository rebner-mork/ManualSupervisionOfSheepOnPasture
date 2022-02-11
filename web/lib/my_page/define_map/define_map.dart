import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../utils/map_utils.dart' as map_utils;

class DefineMap extends StatefulWidget {
  const DefineMap({Key? key}) : super(key: key);

  @override
  State<DefineMap> createState() => _DefineMapState();

  static const String route = 'define-map-widget';
}

class _DefineMapState extends State<DefineMap> {
  _DefineMapState();

  final String mapType = 'topo4';
  MapController _mapController = MapController();
  //Marker _currentPositionMarker =
  //    map_utils.getDevicePositionMarker(LatLng(0, 0));

  final List<Marker> _markers =
      []; // = [_currentPositionMarker, _firstLongpressMarker];

  bool _rectangleDrawn = false;

  Future<void> _moveToStartArea() async {
    LatLng pos = await map_utils.getDevicePosition();
    setState(() {
      _mapController.move(pos, _mapController.zoom);
      //_currentPositionMarker = map_utils.getDevicePositionMarker(pos);
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
            //_moveToStartArea();
          },
          minZoom: 5,
          maxZoom: 18,
          onLongPress: (tapPosition, point) {
            if (_markers.length < 2) {
              setState(() {
                _markers.add(
                    map_utils.getCornerMarker(point, _markers.length == 1));
              });
            } else if (_markers.length == 3 && !_rectangleDrawn) {
              // TODO: draw rectangle
              _rectangleDrawn = true;
            }
          },
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
          MarkerLayerOptions(markers: _markers, rotate: true),
          /*PolylineLayerOptions(polylines: [
            Polyline(
                points: _movementPoints,
                color: Colors.red,
                isDotted: true,
                strokeWidth: 10.0)
          ])*/
        ],
      ),
    );
  }
}
