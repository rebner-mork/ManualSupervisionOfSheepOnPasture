import 'package:app/map/map_widget.dart';
import 'package:app/utils/custom_widgets.dart';
import 'package:app/utils/other.dart';
import 'package:app/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_to_text.dart';

class MainPage extends StatefulWidget {
  const MainPage(this.northWest, this.southEast, {Key? key}) : super(key: key);

  final LatLng northWest;
  final LatLng southEast;

  @override
  State<MainPage> createState() => _MapState();
}

class _MapState extends State<MainPage> {
  late SpeechToText _speechToText;
  final ValueNotifier<bool> _ongoingDialog = ValueNotifier<bool>(false);

  int _sheepAmount = 0;

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
                  onSheepRegistered: (int sheepAmountRegistered) {
                setState(() {
                  if (sheepAmountRegistered > 0) {
                    _sheepAmount += sheepAmountRegistered;
                  }
                });
              })),
      Positioned(
        child: CircularMapButton(
          child: SheepometerIconButton(_sheepAmount),
          width: 62 +
              textSize(_sheepAmount.toString(), circularMapButtonTextStyle)
                  .width,
        ),
        bottom: 8 + MediaQuery.of(context).viewPadding.bottom,
        left: 8,
      ),
      Positioned(
          top: 8 + MediaQuery.of(context).viewPadding.top,
          right: 8,
          child: const CircularMapButton(
            child: SettingsIconButton(),
          ))
    ]));
  }
}
