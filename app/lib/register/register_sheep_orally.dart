import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class RegisterSheepOrallyWidget extends StatefulWidget {
  const RegisterSheepOrallyWidget({Key? key}) : super(key: key);

  static const String route = 'register-sheep-orally';

  @override
  State<RegisterSheepOrallyWidget> createState() => _RegisterSheepOrallyState();
}

enum TtsState { speaking, notSpeaking }

class _RegisterSheepOrallyState extends State<RegisterSheepOrallyWidget> {
  _RegisterSheepOrallyState();

  late FlutterTts _tts;

  TtsState ttsState = TtsState.notSpeaking;

  static const double volume = 0.5;
  static const double pitch = 1.0;
  static const double rate = 0.5;

  get isSpeaking => ttsState == TtsState.speaking;

  @override
  void initState() {
    super.initState();
    initTextToSpeech();
  }

  void initTextToSpeech() {
    _tts = FlutterTts();
    _setAwaitOptions();

    _setHandlers();
    _printTtsInfo();
  }

  Future _setAwaitOptions() async {
    await _tts.awaitSpeakCompletion(true);
    var engine = await _tts.getDefaultEngine;
    debugPrint(engine);
  }

  _setHandlers() {
    _tts.setStartHandler(() {
      debugPrint('Speaking');
      setState(() {
        ttsState = TtsState.speaking;
      });
    });

    _tts.setCompletionHandler(() {
      debugPrint('Not speaking');
      setState(() {
        ttsState = TtsState.notSpeaking;
      });
    });

    _tts.setCancelHandler(() {
      debugPrint('Canceled');
      setState(() {
        ttsState = TtsState.notSpeaking;
      });
    });

    _tts.setErrorHandler((message) {
      debugPrint('Error: $message');
      setState(() {
        ttsState = TtsState.notSpeaking;
      });
    });
  }

  Future _speak() async {
    await _tts.setVolume(volume);
    await _tts.setSpeechRate(rate);
    await _tts.setPitch(pitch);

    await _tts.setLanguage('nb-NO');

    debugPrint('speaking');
    await _tts.speak('Hei, mitt navn er Anders Android');
    debugPrint('not speaking');
  }

  void _printTtsInfo() async {
    var languages = await _tts.getLanguages;
    debugPrint('Språk: ${languages.toString()}');

    var voices = await _tts.getVoices;
    debugPrint('Stemmer: ${voices.toString()}');
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        child: Scaffold(
            appBar: AppBar(
              title: const Text('Registrer sau muntlig'),
            ),
            body: Column(
              children: [
                ElevatedButton(onPressed: _speak, child: const Text('Spytt ut'))
              ],
            )));
  }
}
