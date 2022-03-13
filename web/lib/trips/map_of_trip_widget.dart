import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../utils/map_utils.dart' as map_utils;

class MapOfTripWidget extends StatefulWidget {
  const MapOfTripWidget(
      {required this.track, required this.registrations, Key? key})
      : super(key: key);

  final List<Map<String, double>> track;
  final List<Map<String, dynamic>> registrations;

  @override
  State<MapOfTripWidget> createState() => _MapOfTripWidgetState();
}

class _MapOfTripWidgetState extends State<MapOfTripWidget> {
  _MapOfTripWidgetState();

  MapController _mapController = MapController();
  late List<Polyline> linesOfSight;

  @override
  void initState() {
    super.initState();

    linesOfSight = widget.registrations
        .map((Map<String, dynamic> registration) => Polyline(points: [
              LatLng(registration['devicePosition']['latitude']! as double,
                  registration['devicePosition']['longitude']! as double),
              LatLng(
                  registration['registrationPosition']['latitude']! as double,
                  registration['registrationPosition']['longitude']! as double),
            ], color: Colors.black, isDotted: true, strokeWidth: 5.0))
        .toList();
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
        ),
        layers: [
          TileLayerOptions(
            urlTemplate: map_utils.MapProvider.urlTemplate,
            subdomains: map_utils.MapProvider.subdomains,
            attributionBuilder: (_) {
              return const Text(
                "Kartverket",
                style: TextStyle(color: Colors.black, fontSize: 20),
              );
            },
          ),
          PolylineLayerOptions(polylines: [
            Polyline(
                points: widget.track
                    .map((Map<String, dynamic> point) => LatLng(
                        point['latitude']! as double,
                        point['longitude']! as double))
                    .toList(),
                color: Colors.red,
                strokeWidth: 7.0),
            ...linesOfSight
          ])
        ],
      ),
    );
  }
}
