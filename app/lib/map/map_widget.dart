import 'package:app/register/register_injured_sheep.dart';
import 'package:app/register/register_sheep.dart';
import 'package:app/registration_options.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:latlong2/latlong.dart';
import 'dart:async';

import 'package:speech_to_text/speech_to_text.dart';
import '../utils/map_utils.dart' as map_utils;
import '../utils/constants.dart';

class MapWidget extends StatefulWidget {
  MapWidget(
      {required LatLng northWest,
      required LatLng southEast,
      required this.stt,
      required this.ongoingDialog,
      required this.deviceStartPosition,
      required this.eartags,
      required this.ties,
      required this.registrationType,
      required this.onRegistrationComplete,
      this.onNewPosition,
      Key? key})
      : super(key: key) {
    southWest = LatLng(southEast.latitude, northWest.longitude);
    northEast = LatLng(northWest.latitude, southEast.longitude);
  }

  late final LatLng southWest;
  late final LatLng northEast;

  final SpeechToText stt;
  final ValueNotifier<bool> ongoingDialog;

  final Map<String, bool?> eartags;
  final Map<String, int?> ties;

  final LatLng deviceStartPosition;

  final ValueChanged<Map<String, Object>>? onRegistrationComplete;
  final ValueChanged<LatLng>? onNewPosition;

  late RegistrationTypes registrationType;

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

  bool mapAlreadyTapped = false;

  @override
  void initState() {
    super.initState();

    urlTemplate = map_utils.getLocalUrlTemplate();

    userPosition = widget.deviceStartPosition;
    _currentPositionMarker = map_utils.getDevicePositionMarker(userPosition);
    _movementPoints.add(userPosition);

    timer = Timer.periodic(const Duration(seconds: 30), (_) => _updateMap());
  }

  Future<void> _updateMap() async {
    userPosition = await map_utils.getDevicePosition();
    if (widget.onNewPosition != null) {
      widget.onNewPosition!(userPosition);
    }
    setState(() {
      //_mapController.move(pos, _mapController.zoom);
      _currentPositionMarker = map_utils.getDevicePositionMarker(userPosition);
      _movementPoints.add(userPosition);
    });
  }

  void registerSheep(LatLng targetPosition) async {
    // hvorfor er denne async?
    if (!mapAlreadyTapped) {
      mapAlreadyTapped = true;

      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ValueListenableBuilder<bool>(
                  valueListenable: widget.ongoingDialog,
                  builder: (context, value, child) => RegisterSheep(
                      stt: widget.stt,
                      ongoingDialog: widget.ongoingDialog,
                      sheepPosition: targetPosition,
                      eartags: widget.eartags,
                      ties: widget.ties,
                      onCompletedSuccessfully: (Map<String, Object> data) {
                        mapAlreadyTapped = false;

                        if (data['sheep']! as int > 0) {
                          setState(() {
                            if (widget.onRegistrationComplete != null) {
                              widget.onRegistrationComplete!(data);
                            }
                            LatLng devicePosition = LatLng(
                                (data['devicePosition']!
                                    as Map<String, double>)['latitude']!,
                                (data['devicePosition']!
                                    as Map<String, double>)['longitude']!);

                            linesOfSight.add(Polyline(
                                points: [devicePosition, targetPosition],
                                color: Colors.black,
                                isDotted: true,
                                strokeWidth: 5.0));
                            registrationMarkers
                                .add(map_utils.getSheepMarker(targetPosition));
                          });
                        }
                      },
                      onWillPop: () {
                        mapAlreadyTapped = false;
                      }))));
    }
  }

  void registerInjuredSheep(LatLng targetPosition) {
    debugPrint('Injured sheep');
    if (!mapAlreadyTapped) {
      mapAlreadyTapped = true;

      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => RegisterInjuredSheep(
                  ties: widget.ties,
                  sheepPosition: targetPosition,
                  onCompletedSuccessfully: (Map<String, Object> data) {
                    if (widget.onRegistrationComplete != null) {
                      widget.onRegistrationComplete!(data);
                    }
                  },
                  onWillPop: () {
                    mapAlreadyTapped = false;
                  })));
    }
  }

  void _register(LatLng point) {
    switch (widget.registrationType) {
      case RegistrationTypes.sheep:
        registerSheep(point);
        break;
      case RegistrationTypes.injury:
        registerInjuredSheep(point);
        break;
      default:
    }
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
          },
          onTap: (_, point) => registerSheep(point),
          onLongPress: (_, point) => _register(point),
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
      ),
    );
  }
}
