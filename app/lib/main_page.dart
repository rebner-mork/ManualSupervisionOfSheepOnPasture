import 'dart:async';
import 'dart:collection';

import 'package:app/map/map_widget.dart';
import 'package:app/providers/settings_provider.dart';
import 'package:app/utils/custom_widgets.dart';
import 'package:app/utils/other.dart';
import 'package:app/widgets/circular_buttons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
      Key? key})
      : super(key: key);

  final LatLng northWest;
  final LatLng southEast;
  final String farmId;

  @override
  State<MainPage> createState() => _MapState();
}

class _MapState extends State<MainPage> {
  late SpeechToText _speechToText;
  final ValueNotifier<bool> _ongoingDialog = ValueNotifier<bool>(false);

  int _sheepAmount = 0;
  double iconSize = 42;

  late Map<String, bool> _eartags;
  late Map<String, int> _ties;
  late LatLng _userStartPosition;

  bool _loadingData = true;

  @override
  void initState() {
    super.initState();
    _initSpeechToText();

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _getPositionEartagsAndTies();
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

  Future<void> _getPositionEartagsAndTies() async {
    _userStartPosition = await map_utils.getDevicePosition();

    CollectionReference farmCollection =
        FirebaseFirestore.instance.collection('farms');
    DocumentReference farmDoc = farmCollection.doc(widget.farmId);
    DocumentSnapshot<Object?> doc = await farmDoc.get();

    LinkedHashMap<String, dynamic> dbEartags = await doc.get('eartags');
    LinkedHashMap<String, dynamic> dbTies = await doc.get('ties');

    _eartags = dbEartags.map((key, value) => MapEntry(key, value as bool));
    _ties = dbTies.map((key, value) => MapEntry(key, value as int));
    setState(() {
      _loadingData = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        child: _loadingData
            ? const LoadingData()
            : Stack(children: [
                ValueListenableBuilder<bool>(
                    valueListenable: _ongoingDialog,
                    builder: (context, value, child) => MapWidget(
                            widget.northWest,
                            widget.southEast,
                            _speechToText,
                            _ongoingDialog,
                            userStartPosition: _userStartPosition,
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
