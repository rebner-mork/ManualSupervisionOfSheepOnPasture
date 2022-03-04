import 'package:app/map/map_widget.dart';
import 'package:app/utils/custom_widgets.dart';
import 'package:app/utils/other.dart';
import 'package:app/widgets/circular_buttons.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_to_text.dart';

class MainPage extends StatefulWidget {
  const MainPage(
      {required this.northWest,
      required this.southEast,
      required this.userStartPosition,
      Key? key})
      : super(key: key);

  final LatLng northWest;
  final LatLng southEast;
  final LatLng userStartPosition;

  @override
  State<MainPage> createState() => _MapState();
}

class _MapState extends State<MainPage> {
  late SpeechToText _speechToText;
  final ValueNotifier<bool> _ongoingDialog = ValueNotifier<bool>(false);

  int _sheepAmount = 0;
  double iconSize = 42;

  @override
  void initState() {
    super.initState();
    _initSpeechToText();
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

  @override
  Widget build(BuildContext context) {
    return Material(
        child: Stack(children: [
      ValueListenableBuilder<bool>(
          valueListenable: _ongoingDialog,
          builder: (context, value, child) => MapWidget(widget.northWest,
                  widget.southEast, _speechToText, _ongoingDialog,
                  userStartPosition: widget.userStartPosition,
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
                  context: context, builder: (_) => const SettingsDialog());
            },
          )),
      Positioned(
        bottom: 8 + MediaQuery.of(context).viewPadding.bottom,
        left: 8,
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
