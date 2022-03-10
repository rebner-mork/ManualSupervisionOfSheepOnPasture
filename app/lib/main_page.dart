import 'package:app/trip/end_trip_dialog.dart';
import 'package:app/trip/start_trip_page.dart';
import 'package:app/trip/trip_data.dart';
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

class MainPage extends StatefulWidget {
  MainPage(
      {required this.northWest,
      required this.southEast,
      required this.userStartPosition,
      required this.trip,
      Key? key})
      : super(key: key) {
    trip.track.add(userStartPosition);
  }

  final LatLng northWest;
  final LatLng southEast;
  final LatLng userStartPosition;
  final TripDataManager trip;

  @override
  State<MainPage> createState() => _MapState();
}

class _MapState extends State<MainPage> {
  late SpeechToText _speechToText;
  final ValueNotifier<bool> _ongoingDialog = ValueNotifier<bool>(false);

  int _sheepAmount = 0;
  static const double iconSize = 42;
  static const double buttonInset = 8;

  final Map<String, Object> tripData = {};

  @override
  void initState() {
    super.initState();
    _initSpeechToText();
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

  @override
  Widget build(BuildContext context) {
    return Material(
        child: Stack(children: [
      ValueListenableBuilder<bool>(
          valueListenable: _ongoingDialog,
          builder: (context, value, child) => MapWidget(
                widget.northWest,
                widget.southEast,
                _speechToText,
                _ongoingDialog,
                userStartPosition: widget.userStartPosition,
                onSheepRegistered: (Map<String, Object> data) {
                  int sheepAmountRegistered = data['sheep']! as int;
                  if (sheepAmountRegistered > 0) {
                    setState(() {
                      _sheepAmount += sheepAmountRegistered;
                      widget.trip.registrations.add(data);
                    });
                  }
                },
                onNewPosition: (position) => widget.trip.track.add(position),
              )),
      Positioned(
        top: buttonInset + MediaQuery.of(context).viewPadding.top,
        left: buttonInset,
        child: CircularButton(
            child: const Icon(
              Icons.cloud_upload,
              size: iconSize,
            ),
            onPressed: () {
              _endTripButtonPressed(context, widget.trip);
            }),
      ),
      Positioned(
          top: buttonInset + MediaQuery.of(context).viewPadding.top,
          right: buttonInset,
          child: CircularButton(
            child: const SettingsIcon(iconSize: iconSize),
            onPressed: () {
              showDialog(
                  context: context, builder: (_) => const SettingsDialog());
            },
          )),
      Positioned(
        bottom: buttonInset + MediaQuery.of(context).viewPadding.bottom,
        left: buttonInset,
        child: CircularButton(
          child: Sheepometer(sheepAmount: _sheepAmount, iconSize: iconSize),
          onPressed: () {},
          width: 62 +
              textSize(_sheepAmount.toString(), circularButtonTextStyle).width,
        ),
      ),
    ]));
  }
}

Future<void> _endTripButtonPressed(
    BuildContext context, TripDataManager trip) async {
  await showEndTripDialog(context).then((isFinished) {
    if (isFinished) {
      trip.post();
      Navigator.popUntil(context, ModalRoute.withName(StartTripPage.route));
    }
  });
}
