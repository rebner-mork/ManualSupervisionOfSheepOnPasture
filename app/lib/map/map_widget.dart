import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:latlong2/latlong.dart';
import 'dart:async';

import 'package:app/register/register_sheep_orally.dart';
import 'package:speech_to_text/speech_to_text.dart';
import '../utils/map_utils.dart' as map_utils;
import '../utils/constants.dart';

class MapWidget extends StatefulWidget {
  MapWidget(LatLng northWest, LatLng southEast, this.stt, this.ongoingDialog,
      {required this.userStartPosition, this.onSheepRegistered, Key? key})
      : super(key: key) {
    southWest = LatLng(southEast.latitude, northWest.longitude);
    northEast = LatLng(northWest.latitude, southEast.longitude);
  }

  late final LatLng southWest;
  late final LatLng northEast;

  final SpeechToText stt;
  final ValueNotifier<bool> ongoingDialog;

  final LatLng userStartPosition;
  final ValueChanged<int>? onSheepRegistered;

  @override
  State<MapWidget> createState() => _MapState();
}

class _MapState extends State<MapWidget> {
  MapController _mapController = MapController();
  late LatLng userPosition;

  late Marker _currentPositionMarker;
  List<Marker> registrationMarkers = [];
  final List<LatLng> _movementPoints = [];
  List<Polyline> linesOfSight = [];

  late Timer timer;

  late String urlTemplate;
  bool urlTemplateLoaded = false;

  @override
  void initState() {
    super.initState();

    userPosition = widget.userStartPosition;
    _currentPositionMarker = map_utils.getDevicePositionMarker(userPosition);
    _movementPoints.add(userPosition);

    timer = Timer.periodic(const Duration(seconds: 30), (_) => _updateMap());

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _loadUrlTemplate();
    });
  }

  Future<void> _updateMap() async {
    userPosition = await map_utils.getDevicePosition();
    setState(() {
      //_mapController.move(pos, _mapController.zoom);
      _currentPositionMarker = map_utils.getDevicePositionMarker(userPosition);
      _movementPoints.add(userPosition);
    });
  }

  Future<void> _loadUrlTemplate() async {
    urlTemplate = map_utils.getLocalUrlTemplate();
    setState(() {
      urlTemplateLoaded = true;
    });
  }

  void registerSheepByTap(LatLng targetPosition) async {
    LatLng pos = userPosition;
    map_utils.getDevicePosition().then((value) {
      pos = value;
      _movementPoints.add(pos);
    });

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ValueListenableBuilder<bool>(
                valueListenable: widget.ongoingDialog,
                builder: (context, value, child) => RegisterSheepOrally(
                      'filename',
                      widget.stt,
                      widget.ongoingDialog,
                      onCompletedSuccessfully: (int sheepAmountRegistered) {
                        setState(() {
                          if (sheepAmountRegistered > 0) {
                            if (widget.onSheepRegistered != null) {
                              widget.onSheepRegistered!(sheepAmountRegistered);
                            }
                            linesOfSight.add(Polyline(
                                points: [pos, targetPosition],
                                color: Colors.black,
                                isDotted: true,
                                strokeWidth: 5.0));
                            registrationMarkers
                                .add(map_utils.getSheepMarker(targetPosition));
                          }
                        });
                      },
                    ))));
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
                onTap: (_, point) => registerSheepByTap(point),
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
                PolylineLayerOptions(polylines: [
                  Polyline(
                    points: _movementPoints,
                    color: Colors.red,
                    strokeWidth: 7.0,
                  ),
                  ...linesOfSight
                ]),
                MarkerLayerOptions(
                    markers: [_currentPositionMarker, ...registrationMarkers])
              ],
            )
          : const Center(child: Text("Laster inn")),
    );
  }
}
