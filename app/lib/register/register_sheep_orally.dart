import 'dart:convert';
import 'dart:io';

import 'package:app/register/register_sheep.dart';
import 'package:app/utils/custom_widgets.dart';
import 'package:app/utils/question_sets.dart';
import 'package:app/utils/speech_input_filters.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
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

  int questionIndex = 0;

  late FlutterTts _tts;
  static const double volume = 1.0;
  static const double pitch = 1.0;
  static const double rate = 0.5;

  late SpeechToText _stt;
  bool _speechEnabled = false;
  bool ongoingDialog = true;

  final scrollController = ScrollController();
  final headlineTwoKey = GlobalKey();
  final headlineThreeKey = GlobalKey();

  final _formKey = GlobalKey<FormState>();

  final _textControllers = <String, TextEditingController>{
    'sheep': TextEditingController(),
    'lambs': TextEditingController(),
    'white': TextEditingController(),
    'black': TextEditingController(),
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
    _initSpeechToTextAndStartDialog();
  }

  void _initSpeechToTextAndStartDialog() async {
    _stt = SpeechToText();

    _speechEnabled = await _stt.initialize(onError: _sttError);

    if (_speechEnabled) {
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        _startDialog(allSheepQuestions, allSheepQuestionsContexts);
      });
    } else {
      showDialog(
          context: context,
          builder: (_) => speechNotEnabledDialog(context, RegisterSheep.route));
    }
  }

  void _sttError(SpeechRecognitionError error) {
    debugPrint(error.errorMsg);
    if (mounted) {
      setState(() {
        ongoingDialog = false;
      });
    }
  }

  void _startDialog(
      List<String> questions, List<QuestionContext> questionContexts) async {
    setState(() {
      ongoingDialog = true;
    });
    await _speak(questions[questionIndex]);
    await _listen(questionContexts[questionIndex]);
  }

  Future _listen(QuestionContext questionContext) async {
    await _stt.listen(
        partialResults: false,
        onResult: (result) => _onSpeechResult(result, questionContext),
        localeId: 'en-US',
        onDevice: true,
        listenFor: const Duration(seconds: 5) // listenFor is max - NOT min
        );
  }

  void _onSpeechResult(
      SpeechRecognitionResult result, QuestionContext questionContext) async {
    // Always true when 'partialResults: false'
    if (result.finalResult) {
      String spokenWord = result.recognizedWords;

      if (spokenWord == 'previous' || spokenWord == 'back') {
        if (questionIndex > 0) {
          questionIndex--;
        }
        setState(() {
          _textControllers.values.elementAt(questionIndex).text = '';
        });

        await _speak(allSheepQuestions[questionIndex]);
        await _listen(allSheepQuestionsContexts[questionIndex]);
      } else {
        if (questionContext == QuestionContext.numbers &&
            !numbers.contains(spokenWord)) {
          spokenWord = correctErroneousInput(spokenWord, questionContext);
        } else if (questionContext == QuestionContext.colors &&
            !colors.contains(spokenWord)) {
          spokenWord = correctErroneousInput(spokenWord, questionContext);
        }

        if (spokenWord == '') {
          String response =
              "Jeg forstod ikke. " + allSheepQuestions[questionIndex];
          await _speak(response);
          await _listen(allSheepQuestionsContexts[questionIndex]);
        } else {
          await _speak(spokenWord, language: 'en-US');

          setState(() {
            _textControllers.values.elementAt(questionIndex).text = spokenWord;
            // TODO: få textfield sin onChanged eller onSubmitted til å kjøre
          });

          questionIndex++;

          if (questionIndex < allSheepQuestions.length) {
            await _speak(allSheepQuestions[questionIndex]);
            await _listen(allSheepQuestionsContexts[questionIndex]);
          } else {
            questionIndex = 0;
            setState(() {
              ongoingDialog = false;
            });
          }
        }
      }
    }
  }

  void _initTextToSpeech() {
    _tts = FlutterTts();

    _tts.setVolume(volume);
    _tts.setSpeechRate(rate);
    _tts.setPitch(pitch);

    _setAwaitOptions();
  }

  Future _setAwaitOptions() async {
    await _tts.awaitSpeakCompletion(true);
    var engine = await _tts.getDefaultEngine;
    debugPrint(engine);
  }

  Future _speak(String text, {String language = 'nb-NO'}) async {
    await _tts.setLanguage(language);
    await _tts.speak(text);
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
  void dispose() {
    scrollController.dispose();
    _textControllers.forEach((_, controller) {
      controller.dispose();
    });
    super.dispose();
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
                            _stt.stop(),
                            _tts.stop(),
                            setState(() {
                              ongoingDialog = false;
                            }),
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
                floatingActionButton: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: ongoingDialog
                      ? <Widget>[
                          completeRegistrationButton(context, _registerSheep)
                        ]
                      : <Widget>[
                          startDialogButton(() => _startDialog(
                              allSheepQuestions, allSheepQuestionsContexts)),
                          const SizedBox(
                            width: 20,
                          ),
                          completeRegistrationButton(context, _registerSheep)
                        ],
                ),
                floatingActionButtonLocation:
                    MediaQuery.of(context).viewInsets.bottom == 0
                        ? FloatingActionButtonLocation.centerFloat
                        : FloatingActionButtonLocation.endFloat)));
  }
}
