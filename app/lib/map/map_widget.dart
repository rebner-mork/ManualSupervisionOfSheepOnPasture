import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:latlong2/latlong.dart';
import 'dart:async';

import '../utils/map_utils.dart' as map_utils;
import '../utils/constants.dart';

// ignore: must_be_immutable
class Map extends StatefulWidget {
  Map(LatLng northWest, LatLng southEast, {Key? key}) : super(key: key) {
    southWest = LatLng(southEast.latitude, northWest.longitude);
    northEast = LatLng(northWest.latitude, southEast.longitude);
  }

  static const String route = 'map';
  late LatLng southWest;
  late LatLng northEast;

  @override
  State<Map> createState() => _MapState();
}

class _MapState extends State<Map> {
  MapController _mapController = MapController();
  Marker _currentPositionMarker =
      map_utils.getDevicePositionMarker(LatLng(0, 0));
  final List<LatLng> _movementPoints = [];
  late Timer timer;
  late String urlTemplate;
  bool urlTemplateLoaded = false;
  List<Polyline> linesOfSight = [];
  LatLng? userPosition;

  Future<void> _updateMap() async {
    userPosition = await map_utils.getDevicePosition();
    setState(() {
      //_mapController.move(pos, _mapController.zoom);
      _currentPositionMarker = map_utils.getDevicePositionMarker(userPosition!);
      _movementPoints.add(userPosition!);
    });
  }

  Future<void> _loadUrlTemplate() async {
    urlTemplate = await map_utils.getOfflineUrlTemplate();
    setState(() {
      urlTemplateLoaded = true;
    });
  }

  void drawLineOfSight(LatLng targetPosition) {
    setState(() {
      linesOfSight.add(Polyline(
          points: [userPosition!, targetPosition],
          color: Colors.red,
          strokeWidth: 5.0));
    });
  }

  @override
  void initState() {
    super.initState();
    _updateMap(); //to set the position before waiting at startup
    timer = Timer.periodic(const Duration(seconds: 5), (_) => _updateMap());

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _loadUrlTemplate();
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: urlTemplateLoaded
          ? FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                onMapCreated: (c) {
                  _mapController = c;
                },
                onTap: (_, point) => drawLineOfSight(point),
                zoom: OfflineZoomLevels.min,
                minZoom: OfflineZoomLevels.min,
                maxZoom: OfflineZoomLevels.max,
                swPanBoundary: widget.southWest,
                nePanBoundary: widget.northEast,
                center: LatLngBounds(widget.southWest, widget.northEast).center,
              ),
              layers: [
                TileLayerOptions(
                  tileProvider: const FileTileProvider(),
                  urlTemplate: urlTemplate,
                  errorImage: const AssetImage("images/stripes.png"),
                  attributionBuilder: (_) {
                    return const Text(
                      "Kartverket",
                      style: TextStyle(color: Colors.black, fontSize: 10),
                    );
                  },
                ),
                MarkerLayerOptions(
                    markers: [_currentPositionMarker], rotate: true),
                PolylineLayerOptions(polylines: [
                  Polyline(
                      points: _movementPoints,
                      color: Colors.red,
                      isDotted: true,
                      strokeWidth: 10.0),
                  ...linesOfSight
                ])
              ],
            )
          : const Center(child: Text("Laster inn")),
    );
  }
}
