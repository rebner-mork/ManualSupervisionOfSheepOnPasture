import 'package:app/utils/question_sets.dart';
import 'package:app/utils/speech_input_filters.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class RegisterSheepOrallyWidget extends StatefulWidget {
  const RegisterSheepOrallyWidget(this.fileName, {Key? key}) : super(key: key);

  final String fileName;
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

  int maxIndex = 2;
  int index = 0;

  late FlutterTts _tts;
  late TtsState ttsState;
  List<String> nonFilteredAnswers = [];
  List<String> filteredAnswers = [];

  static const double volume = 0.5;
  static const double pitch = 1.0;
  static const double rate = 0.5;

  get isSpeaking => ttsState == TtsState.speaking;

  late SpeechToText _stt;
  late SttState sttState;

  get isListening => sttState == SttState.listening;

  bool _speechEnabled = false;

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
    // TODO: Si ifra, gi tips og gå til vanlig registrering

    setState(() {});
  }

  void _startDialog(
      List<String> questions, List<QuestionContext> questionContexts) async {
    await _speak(questions[index]);
    await _listen(questionContexts[index]);
  }

  // TODO: Sjekke nettvergstilgang OG om vi faktisk har tilgang videre (Se notat https://pub.dev/packages/connectivity_plus/example)
  // edit: NEI, kjør uten nett hver gang, begrunnes med at vårt filter gir 90(?) i treffprosent akkurat som online-utgaven
  Future _listen(QuestionContext questionContext) async {
    // Mange options, se example
    await _stt.listen(
      partialResults: false,
      onResult: (result) => _onSpeechResult(result, questionContext),
    ); // listenFor is max - NOT min
    //localeId: 'en_US',
    /*  onDevice: true,
        listenFor: const Duration(seconds: 5)*/
  }

  // Final flag?
  // TODO: support "previous"
  void _onSpeechResult(
      SpeechRecognitionResult result, QuestionContext questionContext) async {
    if (result.finalResult) {
      debugPrint('final result');
      String spokenWord = result.recognizedWords;

      if (questionContext == QuestionContext.numbers &&
          !numbers.contains(spokenWord)) {
        spokenWord = correctErroneousInput(spokenWord, questionContext);
      } else if (questionContext == QuestionContext.colors &&
          !colors.contains(spokenWord)) {
        spokenWord = correctErroneousInput(spokenWord, questionContext);
      }

      await _speak(spokenWord, language: 'en-US');

      setState(() {
        nonFilteredAnswers.add(result.recognizedWords);
        filteredAnswers.add(spokenWord);
      });

      index++;

      if (index < allSheepQuestions.length) {
        await _speak(allSheepQuestions[index]);
        await _listen(allSheepQuestionsContexts[index]);
      } else {
        index = 0;
      }
    } else {
      debugPrint('IKKE final result');
    }
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

  // TODO: setup i init og speak der det brukes (med mindre settings skal endre seg)
  Future _speak(String text, {String language = 'nb-NO'}) async {
    await _tts.setVolume(volume);
    await _tts.setSpeechRate(rate);
    await _tts.setPitch(pitch);
    await _tts.setLanguage(language);

    await _tts.speak(text);
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
                    onPressed: () => _startDialog(
                        allSheepQuestions, allSheepQuestionsContexts),
                    child: const Text('Spytt ut')),
                Text("Ikke-filtrert: ${nonFilteredAnswers.toString()}"),
                Text("Filtrert:      ${filteredAnswers.toString()}"),
                /*ElevatedButton(
                    onPressed: _listen, child: const Text('Spytt inn')),*/
              ],
            )));
  }
}
