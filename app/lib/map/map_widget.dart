import 'package:app/utils/other.dart';
import 'package:app/utils/styles.dart';
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

  int _sheepAmount = 0;
  Color sheepAmountButtonColor = Colors.green;

  MapController _mapController = MapController();
  LatLng? userPosition;

  Marker _currentPositionMarker =
      map_utils.getDevicePositionMarker(LatLng(0, 0));
  final List<LatLng> _movementPoints = [];
  List<Polyline> linesOfSight = [];

  late Timer timer;

  late String urlTemplate;
  bool urlTemplateLoaded = false;

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
                      'filename',
                      _speechToText,
                      _ongoingDialog,
                      onCompletedSuccessfully: (int sheepAmountRegistered) {
                        setState(() {
                          if (sheepAmountRegistered > 0) {
                            _sheepAmount += sheepAmountRegistered;
                            linesOfSight.add(Polyline(
                                points: [pos, targetPosition],
                                color: Colors.red,
                                strokeWidth: 5.0));
                          }
                        });
                      },
                    ))));
  }

  InkWell _sheepAmountIcon() {
    return InkWell(
        onTapDown: (_) {
          setState(() {
            sheepAmountButtonColor = Colors.green.shade700;
          });
        },
        onTap: () {
          setState(() {
            sheepAmountButtonColor = Colors.green;
          });
        },
        child: Container(
            height: 50,
            width: 62 +
                textSize(
                        _sheepAmount.toString(), sheepAmountRegisteredTextStyle)
                    .width,
            decoration: BoxDecoration(
                color: sheepAmountButtonColor,
                border: circularMapButtonBorder,
                borderRadius:
                    const BorderRadius.all(Radius.elliptical(75, 75))),
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              const Image(
                  image: AssetImage('images/sheep.png'), width: 42, height: 42),
              Text(_sheepAmount.toString(),
                  style: sheepAmountRegisteredTextStyle),
              const SizedBox(
                width: 2,
              )
            ])));
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        child: Stack(children: [
      urlTemplateLoaded
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
      Positioned(
        child: _sheepAmountIcon(),
        bottom: 8,
        left: 8,
      ),
    ]));
  }
}
