import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../utils/map_utils.dart' as map_utils;

class MapOfTripWidget extends StatefulWidget {
  const MapOfTripWidget({Key? key}) : super(key: key);

  @override
  State<MapOfTripWidget> createState() => _MapOfTripWidgetState();
}

class _MapOfTripWidgetState extends State<MapOfTripWidget> {
  _MapOfTripWidgetState();

  MapController _mapController = MapController();

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
        ],
      ),
    );
  }
}
