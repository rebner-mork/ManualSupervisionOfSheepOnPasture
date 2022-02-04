import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class RegisterSheepOrallyWidget extends StatefulWidget {
  const RegisterSheepOrallyWidget({Key? key}) : super(key: key);

  static const String route = 'register-sheep-orally';

  @override
  State<RegisterSheepOrallyWidget> createState() => _RegisterSheepOrallyState();
}

// TODO: Bare én instanse av STT per applikasjon, dvs. at den må passes inn i denne widgeten(?)
// https://pub.dev/packages/speech_to_text#initialize-once

enum TtsState { speaking, notSpeaking }
enum SttState { listening, notListening }

class _RegisterSheepOrallyState extends State<RegisterSheepOrallyWidget> {
  _RegisterSheepOrallyState();

  late FlutterTts _tts;
  late TtsState ttsState;

  static const double volume = 0.5;
  static const double pitch = 1.0;
  static const double rate = 0.5;

  get isSpeaking => ttsState == TtsState.speaking;

  late SpeechToText _stt;
  late SttState sttState;

  get isListening => sttState == SttState.listening;

  bool _speechEnabled = false;
  String _lastWords = '';

  @override
  void initState() {
    super.initState();
    _initTextToSpeech();
    _initSpeechToText();
  }

  void _initSpeechToText() async {
    _stt = SpeechToText();
    _speechEnabled = await _stt.initialize();
    debugPrint('Speech enabled: $_speechEnabled');
    setState(() {});
  }

  void _listen() async {
    //_printSttInfo();
    await _stt.listen(
        onResult: _onSpeechResult,
        //localeId: 'en_US',
        onDevice: true); //en_GB // Mange options, se example
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    debugPrint(result.toString());
    setState(() {
      _lastWords = result.recognizedWords;
    });
  }

  void _printSttInfo() async {
    var locales = await _stt.locales();
    for (LocaleName locale in locales) {
      debugPrint(locale.name + ', ' + locale.localeId);
    }
  }

  void _initTextToSpeech() {
    ttsState = TtsState.notSpeaking;
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

    //debugPrint('speaking');
    await _tts.speak('Hei, mitt navn er Anders Android');
    //debugPrint('not speaking');
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
                ElevatedButton(
                    onPressed: _speak, child: const Text('Spytt ut')),
                ElevatedButton(
                    onPressed: _listen, child: const Text('Spytt inn')),
                Text(_lastWords),
              ],
            )));
  }
}
