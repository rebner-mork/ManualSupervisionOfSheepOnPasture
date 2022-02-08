import 'dart:convert';
import 'dart:io';

import 'package:app/utils/custom_widgets.dart';
import 'package:app/utils/question_sets.dart';
import 'package:app/utils/speech_input_filters.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:fluttericon/rpg_awesome_icons.dart';
import 'package:fluttericon/font_awesome5_icons.dart';

class RegisterSheepOrallyWidget extends StatefulWidget {
  const RegisterSheepOrallyWidget(this.fileName, {Key? key}) : super(key: key);

  final String fileName;
  static const String route = 'register-sheep-orally';

  @override
  State<RegisterSheepOrallyWidget> createState() => _RegisterSheepOrallyState();
}

// TODO: Bare én instanse av STT per applikasjon, dvs. at den
// muligens må passes inn i denne widgeten(?)
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

  final scrollController = ScrollController();
  final headlineTwoKey = GlobalKey();
  final headlineThreeKey = GlobalKey();

  final _formKey = GlobalKey<FormState>();

  final _textControllers = <String, TextEditingController>{
    'sheep': TextEditingController(),
    'lambs': TextEditingController(),
    'black': TextEditingController(),
    'white': TextEditingController(),
    'blackHead': TextEditingController(),
    'redTie': TextEditingController(),
    'blueTie': TextEditingController(),
    'yellowTie': TextEditingController(),
    'redEar': TextEditingController(),
    'blueEar': TextEditingController(),
  };

  @override
  void initState() {
    super.initState();
    _initTextToSpeech();
    _initSpeechToText();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _startDialog(allSheepQuestions, allSheepQuestionsContexts);
    });
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
        localeId: 'en_US',
        onDevice: true,
        listenFor: const Duration(seconds: 5) // listenFor is max - NOT min
        );
  }

  void _onSpeechResult(
      SpeechRecognitionResult result, QuestionContext questionContext) async {
    // Always true when 'partialResults: false'
    if (result.finalResult) {
      debugPrint('final result');
      String spokenWord = result.recognizedWords;

      if (spokenWord == 'previous' || spokenWord == 'back') {
        if (index > 0) {
          index--;
        }
        setState(() {
          if (nonFilteredAnswers.isNotEmpty) {
            nonFilteredAnswers.removeAt(index);
          }
          if (filteredAnswers.isNotEmpty) {
            filteredAnswers.removeAt(index);
          }
        });

        await _speak(allSheepQuestions[index]);
        await _listen(allSheepQuestionsContexts[index]);
      } else {
        if (questionContext == QuestionContext.numbers &&
            !numbers.contains(spokenWord)) {
          spokenWord = correctErroneousInput(spokenWord, questionContext);
        } else if (questionContext == QuestionContext.colors &&
            !colors.contains(spokenWord)) {
          spokenWord = correctErroneousInput(spokenWord, questionContext);
        }

        if (spokenWord == '') {
          String response = "Jeg forstod ikke. " + allSheepQuestions[index];
          await _speak(response);
          await _listen(allSheepQuestionsContexts[index]);
        } else {
          await _speak(spokenWord, language: 'en-US');

          setState(() {
            _textControllers[index]!.text = spokenWord;
            //nonFilteredAnswers.insert(index, result.recognizedWords);
            //filteredAnswers.insert(index, spokenWord);
          });

          index++;

          if (index < allSheepQuestions.length) {
            await _speak(allSheepQuestions[index]);
            await _listen(allSheepQuestionsContexts[index]);
          } else {
            index = 0;
          }
        }
      }
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

  _registerSheep() async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final String path = directory.path;

    final File file = File('$path/${widget.fileName}.json');
    final Map data = _gatherData();

    file.writeAsString(json.encode(data));
  }

  Map _gatherData() {
    return <String, int>{
      'sheep': _textControllers['sheep']!.text.isEmpty
          ? 0
          : int.parse(_textControllers['sheep']!.text),
      'lambs': _textControllers['lambs']!.text.isEmpty
          ? 0
          : int.parse(_textControllers['lambs']!.text),
      'white': _textControllers['white']!.text.isEmpty
          ? 0
          : int.parse(_textControllers['white']!.text),
      'black': _textControllers['black']!.text.isEmpty
          ? 0
          : int.parse(_textControllers['black']!.text),
      'blackHead': _textControllers['blackHead']!.text.isEmpty
          ? 0
          : int.parse(_textControllers['blackHead']!.text),
      'redTie': _textControllers['redTie']!.text.isEmpty
          ? 0
          : int.parse(_textControllers['redTie']!.text),
      'blueTie': _textControllers['blueTie']!.text.isEmpty
          ? 0
          : int.parse(_textControllers['blueTie']!.text),
      'yellowTie': _textControllers['yellowTie']!.text.isEmpty
          ? 0
          : int.parse(_textControllers['yellowTie']!.text),
      'redEar': _textControllers['redEar']!.text.isEmpty
          ? 0
          : int.parse(_textControllers['redEar']!.text),
      'blueEar': _textControllers['blueEar']!.text.isEmpty
          ? 0
          : int.parse(_textControllers['blueEar']!.text),
    };
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        child: Form(
            key: _formKey,
            child: Scaffold(
                appBar: AppBar(
                  title: const Text('Registrer sau muntlig'),
                  leading: BackButton(
                      onPressed: () => {
                            if (isListening)
                              {
                                _stt.stop() // TODO: sjekk om fungerer
                              },
                            showDialog(
                                context: context,
                                builder: (_) =>
                                    cancelRegistrationDialog(context))
                          }),
                ),
                body: SingleChildScrollView(
                    controller: scrollController,
                    child: Center(
                        child: Column(children: [
                      const SizedBox(height: 10),
                      inputDividerWithHeadline('Antall'),
                      inputRow('Sauer', _textControllers['sheep']!,
                          RpgAwesome.sheep, Colors.grey),
                      inputFieldSpacer(),
                      inputRow('Lam', _textControllers['lambs']!,
                          RpgAwesome.sheep, Colors.grey,
                          iconSize: 24),
                      inputFieldSpacer(),

                      inputRow(
                        'Hvite',
                        _textControllers['white']!,
                        RpgAwesome.sheep,
                        Colors.white,
                      ),
                      inputFieldSpacer(),
                      inputRow(
                        'Svarte',
                        _textControllers['black']!,
                        RpgAwesome.sheep,
                        Colors.black,
                      ),
                      inputFieldSpacer(),
                      inputRow('Svart hode', _textControllers['blackHead']!,
                          RpgAwesome.sheep, Colors.black,
                          scrollController: scrollController,
                          fieldAmount: 5,
                          key: headlineTwoKey),

                      inputDividerWithHeadline('Slips', headlineTwoKey),

                      // TODO: Conditional basert på mulige farger
                      inputRow(
                        'Røde',
                        _textControllers['redTie']!,
                        FontAwesome5.black_tie,
                        Colors.red,
                      ),
                      inputFieldSpacer(),
                      inputRow(
                        'Blå',
                        _textControllers['blueTie']!,
                        FontAwesome5.black_tie,
                        Colors.blue,
                      ),
                      inputFieldSpacer(),
                      inputRow('Gule', _textControllers['yellowTie']!,
                          FontAwesome5.black_tie, Colors.yellow,
                          scrollController: scrollController,
                          fieldAmount: 3,
                          key: headlineThreeKey),
                      // TODO: Conditional basert på mulige farger

                      inputDividerWithHeadline('Øremerker', headlineThreeKey),

                      inputRow(
                        'Røde',
                        _textControllers['redEar']!,
                        Icons.local_offer,
                        Colors.red,
                      ),
                      inputFieldSpacer(),
                      inputRow(
                        'Blå',
                        _textControllers['blueEar']!,
                        Icons.local_offer,
                        Colors.blue,
                      ),
                      inputFieldSpacer(),
                      const SizedBox(height: 80),
                    ]))),
                floatingActionButton:
                    MediaQuery.of(context).viewInsets.bottom == 0
                        ? FloatingActionButton.extended(
                            onPressed: _registerSheep,
                            label: const Text('Fullfør registrering',
                                style: TextStyle(fontSize: 19)))
                        : FloatingActionButton(
                            onPressed: _registerSheep,
                            child: const Icon(
                              Icons.check,
                              size: 35,
                            )),
                floatingActionButtonLocation: MediaQuery.of(context)
                            .viewInsets
                            .bottom ==
                        0
                    ? FloatingActionButtonLocation.centerFloat
                    : FloatingActionButtonLocation
                        .endFloat) /*Column(
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
                ))*/
            ));
  }
}
