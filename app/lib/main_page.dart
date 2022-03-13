import 'package:app/map/map_widget.dart';
import 'package:app/trip/end_trip_dialog.dart';
import 'package:app/trip/start_trip_page.dart';
import 'package:app/trip/trip_data.dart';
import 'package:app/utils/custom_widgets.dart';
import 'package:app/utils/other.dart';
import 'package:app/widgets/circular_buttons.dart';

import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:speech_to_text/speech_to_text.dart';

class MainPage extends StatefulWidget {
  const MainPage(
      {required this.speechToText,
      required this.ongoingDialog,
      required this.northWest,
      required this.southEast,
      required this.userStartPosition,
      required this.farmId,
      required this.personnelEmail,
      required this.mapName,
      Key? key})
      : super(key: key);

  final SpeechToText speechToText;
  final ValueNotifier<bool> ongoingDialog;
  final LatLng northWest;
  final LatLng southEast;
  final String farmId;
  final String personnelEmail;
  final String mapName;
  final LatLng userStartPosition;

  @override
  State<MainPage> createState() => _MapState();
}

class _MapState extends State<MainPage> {
  int _sheepAmount = 0;
  static const double iconSize = 42;
  static const double buttonInset = 8;
  late final TripDataManager _tripData;

  @override
  void initState() {
    super.initState();
    _tripData = TripDataManager.start(
        farmId: widget.farmId,
        personnelEmail: widget.personnelEmail,
        mapName: widget.mapName);
    _tripData.track.add(widget.userStartPosition);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        child: Stack(children: [
      ValueListenableBuilder<bool>(
          valueListenable: widget.ongoingDialog,
          builder: (context, value, child) => MapWidget(
                widget.northWest,
                widget.southEast,
                widget.speechToText,
                widget.ongoingDialog,
                userStartPosition: widget.userStartPosition,
                onSheepRegistered: (Map<String, Object> data) {
                  int sheepAmountRegistered = data['sheep']! as int;
                  if (sheepAmountRegistered > 0) {
                    _tripData.registrations.add(data);
                    setState(() {
                      _sheepAmount += sheepAmountRegistered;
                    });
                  }
                },
                onNewPosition: (position) => _tripData.track.add(position),
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
              _endTripButtonPressed(context, _tripData);
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
    BuildContext context, TripDataManager _trip) async {
  await showEndTripDialog(context).then((isFinished) {
    if (isFinished) {
      _trip.post();
      Navigator.popUntil(context, ModalRoute.withName(StartTripPage.route));
    }
  });
}
