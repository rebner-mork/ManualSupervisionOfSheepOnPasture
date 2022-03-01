import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:latlong2/latlong.dart';
import 'dart:async';

import 'package:app/register/register_sheep_orally.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_to_text.dart';
import '../utils/map_utils.dart' as map_utils;
import '../utils/constants.dart';

class MapWidget extends StatefulWidget {
  MapWidget(LatLng northWest, LatLng southEast, {Key? key}) : super(key: key) {
    southWest = LatLng(southEast.latitude, northWest.longitude);
    northEast = LatLng(northWest.latitude, southEast.longitude);
  }

  late final LatLng southWest;
  late final LatLng northEast;

  @override
  State<MapWidget> createState() => _MapState();
}

class _MapState extends State<MapWidget> {
  late SpeechToText _speechToText;
  final ValueNotifier<bool> _ongoingDialog = ValueNotifier<bool>(false);

  MapController _mapController = MapController();
  Marker _currentPositionMarker =
      map_utils.getDevicePositionMarker(LatLng(0, 0));
  List<Marker> registrationMarkers = [];
  final List<LatLng> _movementPoints = [];
  late Timer timer;
  late String urlTemplate;
  bool urlTemplateLoaded = false;
  List<Polyline> linesOfSight = [];
  LatLng? userPosition;

  @override
  void initState() {
    super.initState();
    _initSpeechToText();
    _updateMap(); //to set the position before waiting at startup
    timer = Timer.periodic(const Duration(seconds: 30), (_) => _updateMap());

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _loadUrlTemplate();
    });
  }

  void _initSpeechToText() async {
    _speechToText = SpeechToText();
    await _speechToText.initialize(onError: _speechToTextError);
  }

  void _speechToTextError(SpeechRecognitionError error) {
    setState(() {
      _ongoingDialog.value = false;
    });
  }

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

  void registerSheepByTap(LatLng targetPosition) async {
    LatLng pos = userPosition!;
    map_utils.getDevicePosition().then((value) {
      pos = value;
      _movementPoints.add(pos);
    });

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ValueListenableBuilder<bool>(
                  valueListenable: _ongoingDialog,
                  builder: (context, value, child) => RegisterSheepOrally(
                      'filename', _speechToText, _ongoingDialog,
                      onCompletedSuccessfully: () {
                    setState(() {
                      linesOfSight.add(Polyline(
                          points: [pos, targetPosition],
                          color: Colors.black,
                          isDotted: true,
                          strokeWidth: 5.0));
                      registrationMarkers
                          .add(map_utils.getSheepMarker(targetPosition));
                    });
                  }),
                )));
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
