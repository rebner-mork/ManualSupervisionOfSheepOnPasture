import 'dart:async';

import 'package:app/map/map_widget.dart';
import 'package:app/providers/settings_provider.dart';
import 'package:app/utils/custom_widgets.dart';
import 'package:app/utils/other.dart';
import 'package:app/widgets/circular_buttons.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_to_text.dart';
import '../utils/map_utils.dart' as map_utils;

class MainPage extends StatefulWidget {
  const MainPage(
      {required this.northWest,
      required this.southEast,
      required this.farmId,
      required this.eartags,
      required this.ties,
      Key? key})
      : super(key: key);

  final LatLng northWest;
  final LatLng southEast;
  final String farmId;
  final Map<String, bool> eartags;
  final Map<String, int> ties;

  @override
  State<MainPage> createState() => _MapState();
}

class _MapState extends State<MainPage> {
  late SpeechToText _speechToText;
  final ValueNotifier<bool> _ongoingDialog = ValueNotifier<bool>(false);

  late LatLng _deviceStartPosition;

  int _sheepAmount = 0;
  double iconSize = 42;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initSpeechToText();

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _setDeviceStartPosition();
    });
  }

  void _initSpeechToText() async {
    _speechToText = SpeechToText();
    await _speechToText.initialize(onError: _speechToTextError);
    Provider.of<SettingsProvider>(context, listen: false)
        .setSttAvailability(_speechToText.isAvailable);
  }

  void _speechToTextError(SpeechRecognitionError error) {
    setState(() {
      _ongoingDialog.value = false;
    });
  }

  Future<void> _setDeviceStartPosition() async {
    _deviceStartPosition = await map_utils.getDevicePosition();

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        child: _isLoading
            ? const LoadingData()
            : Stack(children: [
                ValueListenableBuilder<bool>(
                    valueListenable: _ongoingDialog,
                    builder: (context, value, child) => MapWidget(
                            widget.northWest,
                            widget.southEast,
                            _speechToText,
                            _ongoingDialog,
                            widget.eartags,
                            widget.ties,
                            userStartPosition: _deviceStartPosition,
                            onSheepRegistered: (int sheepAmountRegistered) {
                          setState(() {
                            if (sheepAmountRegistered > 0) {
                              _sheepAmount += sheepAmountRegistered;
                            }
                          });
                        })),
                Positioned(
                    top: 8 + MediaQuery.of(context).viewPadding.top,
                    right: 8,
                    child: CircularButton(
                      child: SettingsIcon(iconSize: iconSize),
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (_) => const SettingsDialog());
                      },
                    )),
                Positioned(
                  bottom: 8 + MediaQuery.of(context).viewPadding.bottom,
                  left: 8,
                  child: CircularButton(
                    child: Sheepometer(
                        sheepAmount: _sheepAmount, iconSize: iconSize),
                    onPressed: () {},
                    width: 62 +
                        textSize(_sheepAmount.toString(),
                                circularButtonTextStyle)
                            .width,
                  ),
                ),
              ]));
  }
}
