import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../utils/map_utils.dart' as map_utils;

class DefineMap extends StatefulWidget {
  const DefineMap(this.onCornerMarked, this.secondMarkerIncorrectlyPlaced,
      {Key? key})
      : super(key: key);

  @override
  State<DefineMap> createState() => _DefineMapState();

  static const String route = 'define-map-widget';
  final Function(List<LatLng> points) onCornerMarked;
  final Function() secondMarkerIncorrectlyPlaced;
}

class _DefineMapState extends State<DefineMap> {
  _DefineMapState();

  final String mapType = 'topo4';
  MapController _mapController = MapController();
  //Marker _currentPositionMarker =
  //    map_utils.getDevicePositionMarker(LatLng(0, 0));

  final List<Marker> _markers = [];

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
          },
          zoom: 5,
          minZoom: 5,
          maxZoom: 18,
          center: LatLng(65, 13),
          onLongPress: (tapPosition, point) {
            debugPrint(point.toString());

            if (_markers.isEmpty ||
                (_markers.length == 1 &&
                    _isSecondMarkerPlacedCorrectly(point))) {
              setState(() {
                _markers.add(
                    map_utils.getCornerMarker(point, _markers.length == 1));
              });
              widget.onCornerMarked([_markers[0].point]);
              if (_markers.length == 2 && !_rectangleDrawn) {
                Future.delayed(const Duration(milliseconds: 500), () {
                  setState(() {
                    _rectangleDrawn = true;
                  });
                });
                widget.onCornerMarked([_markers[0].point, _markers[1].point]);
              }
            } else {
              widget.secondMarkerIncorrectlyPlaced();
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
          if (!_rectangleDrawn)
            MarkerLayerOptions(markers: _markers, rotate: true),
          if (_rectangleDrawn)
            PolylineLayerOptions(polylines: [
              Polyline(
                  points: drawMapArea(),
                  color: Colors.red,
                  isDotted: false,
                  strokeWidth: 3.0)
            ])
        ],
      ),
    );
  }

  List<LatLng> drawMapArea() {
    return [
      _markers[0].point,
      LatLng(_markers[1].point.latitude, _markers[0].point.longitude),
      _markers[1].point,
      LatLng(_markers[0].point.latitude, _markers[1].point.longitude),
      _markers[0].point
    ];
  }

  bool _isSecondMarkerPlacedCorrectly(LatLng se) {
    LatLng nw = _markers[0].point;

    return (se.latitude < nw.latitude && se.longitude > nw.longitude);
  }
}
