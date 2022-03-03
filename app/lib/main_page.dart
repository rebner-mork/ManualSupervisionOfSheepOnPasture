import 'package:app/map/map_widget.dart';
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
  Color sheepAmountButtonColor = Colors.green;

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
        child: Sheepometer(_sheepAmount, sheepAmountButtonColor),
        bottom: 8 + MediaQuery.of(context).viewPadding.bottom,
        left: 8,
      ),
      Positioned(
        child: IconButton(
          icon: const Icon(
            Icons.settings,
            size: 44,
          ),
          onPressed: () {
            // TODO: showDialog? https://stackoverflow.com/questions/54480641/flutter-how-to-create-forms-in-popup
          },
        ),
        top: 8 + MediaQuery.of(context).viewPadding.top,
        right: 8,
      )
    ]));
  }
}

class Sheepometer extends StatefulWidget {
  Sheepometer(this.sheepAmount, this.color, {Key? key}) : super(key: key);

  int sheepAmount;
  Color color;

  @override
  State<Sheepometer> createState() => _SheepometerState();
}

class _SheepometerState extends State<Sheepometer> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTapDown: (_) {
          setState(() {
            widget.color = Colors.green.shade700;
          });
        },
        onTap: () {
          setState(() {
            widget.color = Colors.green;
          });
        },
        child: Container(
            height: 50,
            width: 62 +
                textSize(widget.sheepAmount.toString(),
                        circularMapButtonTextStyle)
                    .width,
            decoration: BoxDecoration(
                color: widget.color,
                border: circularMapButtonBorder,
                borderRadius:
                    const BorderRadius.all(Radius.elliptical(75, 75))),
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              const Image(
                  image: AssetImage('images/sheep.png'), width: 42, height: 42),
              Text(widget.sheepAmount.toString(),
                  style: circularMapButtonTextStyle),
              const SizedBox(
                width: 2,
              )
            ])));
  }
}
