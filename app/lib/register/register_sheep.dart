import 'package:app/providers/settings_provider.dart';
import 'package:app/register/register_page.dart';
import 'package:app/utils/constants.dart';
import 'package:app/utils/custom_widgets.dart';
import 'package:app/utils/other.dart';
import 'package:app/utils/question_sets.dart';
import 'package:app/utils/speech_input_filters.dart';
import 'package:app/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:provider/provider.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:fluttericon/rpg_awesome_icons.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:latlong2/latlong.dart';
import '../utils/map_utils.dart' as map_utils;

class RegisterSheep extends StatefulWidget {
  const RegisterSheep(
      {required this.stt,
      required this.ongoingDialog,
      required this.sheepPosition,
      required this.eartags,
      required this.ties,
      this.onCompletedSuccessfully,
      this.onWillPop,
      Key? key})
      : super(key: key);

  final SpeechToText stt;
  final ValueNotifier<bool> ongoingDialog;

  final LatLng sheepPosition;

  final Map<String, bool?> eartags;
  final Map<String, int?> ties;

  final ValueChanged<Map<String, Object>>? onCompletedSuccessfully;
  final VoidCallback? onWillPop;

  @override
  State<RegisterSheep> createState() => _RegisterSheepState();
}

class _RegisterSheepState extends State<RegisterSheep> with RegisterPage {
  _RegisterSheepState();

  String title = 'Avstandsregistrering sau';

  int questionIndex = 0;

  late FlutterTts _tts;
  static const double volume = 1.0;
  static const double pitch = 1.0;
  static const double rate = 0.5;

  final _formKey = GlobalKey<FormState>();

  final scrollController = ScrollController();
  final List<GlobalKey> firstHeadlineFieldKeys = [
    GlobalKey(),
    GlobalKey(),
    GlobalKey()
  ];
  final List<int> firstHeadlineFieldIndexes = [distanceSheepQuestions.length];
  int currentHeadlineIndex = 0;

  final _textControllers = <String, TextEditingController>{
    'sheep': TextEditingController(),
    'lambs': TextEditingController(),
    'white': TextEditingController(),
    'brown': TextEditingController(),
    'black': TextEditingController(),
    'blackHead': TextEditingController(),
  };

  late LatLng _devicePosition;
  final Distance distance = const Distance();
  late bool _isShortDistance;

  late List<String> questions;
  late List<QuestionContext> questionContexts;

  List<String> numbers = numbersFilter.keys.toList();
  List<String> colors = colorsFilter.keys.toList();

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    _initTextToSpeech();

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _initGpsQuestionsAndDialog();
    });
  }

  Future<void> _initGpsQuestionsAndDialog() async {
    // TODO: try/catch (Unhandled Exception: Location services does not have permissions)
    await getDevicePosition();
    _isShortDistance =
        distance.distance(_devicePosition, widget.sheepPosition) < 50;

    questions = List.from(distanceSheepQuestions);
    questionContexts = [
      QuestionContext.numbers,
      QuestionContext.numbers,
      QuestionContext.numbers,
      QuestionContext.numbers,
      QuestionContext.numbers,
      QuestionContext.numbers
    ];

    if (_isShortDistance) {
      title = 'Nærregistrering sau';

      for (String eartagColor in widget.eartags.keys) {
        questions.add(closeSheepQuestions['eartags']![eartagColor]!);
        questionContexts.add(QuestionContext.numbers);
        _textControllers['${colorValueStringToColorString[eartagColor]}Ear'] =
            TextEditingController();
      }

      firstHeadlineFieldIndexes.add(questions.length);

      for (String tieColor in widget.ties.keys) {
        questions.add(closeSheepQuestions['ties']![tieColor]!);
        questionContexts.add(QuestionContext.numbers);
        _textControllers['${colorValueStringToColorString[tieColor]}Tie'] =
            TextEditingController();
      }
    }

    setState(() {
      _isLoading = false;
    });

    if (Provider.of<SettingsProvider>(context, listen: false).autoDialog) {
      if (widget.stt.isAvailable) {
        _startDialog(questions, questionContexts);
      }
    }
  }

  @override
  Future<void> getDevicePosition() async {
    _devicePosition = await map_utils.getDevicePosition();
  }

  void _startDialog(
      List<String> questions, List<QuestionContext> questionContexts) async {
    setState(() {
      widget.ongoingDialog.value = true;
      FocusManager.instance.primaryFocus?.unfocus();
    });
    await _speak(questions[questionIndex]);
    await _listen(questionContexts[questionIndex]);
  }

  Future<void> _listen(QuestionContext questionContext) async {
    await widget.stt.listen(
        onResult: (result) => _onSpeechResult(result, questionContext),
        localeId: 'en-US',
        onDevice: true,
        listenFor: const Duration(seconds: 5));
  }

  void _onSpeechResult(
      SpeechRecognitionResult result, QuestionContext questionContext) async {
    if (result.finalResult) {
      String spokenWord = result.recognizedWords;

      if (spokenWord == 'previous' || spokenWord == 'back') {
        if (questionIndex > 0) {
          if (questionIndex == firstHeadlineFieldIndexes[0] ||
              questionIndex == firstHeadlineFieldIndexes[1]) {
            currentHeadlineIndex--;
          }
          questionIndex--;
        }
        setState(() {
          _textControllers.values.elementAt(questionIndex).text = '';
        });

        await _speak(questions[questionIndex]);
        await _listen(questionContexts[questionIndex]);
      } else {
        if (questionContext == QuestionContext.numbers &&
            !numbers.contains(spokenWord)) {
          spokenWord = correctErroneousInput(spokenWord, questionContext);
        } else if (questionContext == QuestionContext.colors &&
            !colors.contains(spokenWord)) {
          spokenWord = correctErroneousInput(spokenWord, questionContext);
        }

        if (spokenWord == '') {
          String response = "Jeg forstod ikke. " + questions[questionIndex];
          await _speak(response);
          await _listen(questionContexts[questionIndex]);
        } else {
          if (Provider.of<SettingsProvider>(context, listen: false).readBack) {
            await _speak(spokenWord, language: 'en-US');
          }

          setState(() {
            _textControllers.values.elementAt(questionIndex).text = spokenWord;
          });

          questionIndex++;

          if (questionIndex < questions.length) {
            if (firstHeadlineFieldIndexes.contains(questionIndex)) {
              scrollToKey(scrollController,
                  firstHeadlineFieldKeys[currentHeadlineIndex++]);
            }

            await _speak(questions[questionIndex]);
            await _listen(questionContexts[questionIndex]);
          } else {
            questionIndex = 0;
            currentHeadlineIndex = 0;
            setState(() {
              widget.ongoingDialog.value = false;
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

  Future<void> _setAwaitOptions() async {
    await _tts.awaitSpeakCompletion(true);
  }

  Future<void> _speak(String text, {String language = 'nb-NO'}) async {
    await _tts.setLanguage(language);
    await _tts.speak(text);
  }

  @override
  void register() {
    Map<String, Object> data = {
      ...getMetaRegistrationData(
          type: 'sheep',
          devicePosition: _devicePosition,
          registrationPosition: widget.sheepPosition),
      ...gatherRegisteredData(_textControllers)
    };

    if (widget.onCompletedSuccessfully != null) {
      widget.onCompletedSuccessfully!(data);
    }
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }

  Future<void> _backButtonPressed() async {
    if (widget.stt.isAvailable) {
      widget.stt.stop();
      _tts.stop();
      setState(() {
        widget.ongoingDialog.value = false;
      });
    }
    await cancelRegistrationDialog(context).then((value) => {
          if (value)
            {
              if (widget.onWillPop != null) {widget.onWillPop!()},
              Navigator.pop(context)
            }
        });
  }

  Future<bool> _onWillPop() async {
    if (widget.stt.isAvailable) {
      widget.stt.stop();
      _tts.stop();
      setState(() {
        widget.ongoingDialog.value = false;
      });
    }

    return onWillPop(context, widget.onWillPop);
  }

  List<Widget> _shortDistance() {
    List eartags = [];
    List<Widget> ties = [];

    if (widget.eartags.isNotEmpty) {
      eartags.add(
          inputDividerWithHeadline('Øremerker', firstHeadlineFieldKeys[1]));
      for (String eartagColor in widget.eartags.keys) {
        eartags.add(inputRow(
            colorValueStringToColorStringGuiPlural[eartagColor]!,
            _textControllers[
                '${colorValueStringToColorString[eartagColor]}Ear']!,
            eartagColor == '0' ? Icons.close : Icons.local_offer,
            eartagColor == '0' ? Colors.grey : colorStringToColor[eartagColor]!,
            scrollController: widget.ties.isNotEmpty &&
                    eartagColor == widget.eartags.keys.last
                ? scrollController
                : null,
            key: widget.ties.isNotEmpty &&
                    eartagColor == widget.eartags.keys.last
                ? firstHeadlineFieldKeys[2]
                : null));
        eartags.add(inputFieldSpacer());
      }
    }

    if (widget.ties.isNotEmpty) {
      ties.add(inputDividerWithHeadline('Slips', firstHeadlineFieldKeys[2]));
      for (String tieColor in widget.ties.keys) {
        ties.add(inputRow(
            colorValueStringToColorStringGuiPlural[tieColor]!,
            _textControllers['${colorValueStringToColorString[tieColor]}Tie']!,
            tieColor == '0' ? Icons.close : FontAwesome5.black_tie,
            tieColor == '0' ? Colors.grey : colorStringToColor[tieColor]!));
        ties.add(inputFieldSpacer());
      }
    }

    return [...eartags, ...ties];
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
            onWillPop: _onWillPop,
            child: Scaffold(
                appBar: AppBar(
                  title: Text(title, style: appBarTextStyle),
                  leading: BackButton(onPressed: _backButtonPressed),
                ),
                body: _isLoading
                    ? const LoadingData()
                    : SingleChildScrollView(
                        controller: scrollController,
                        child: Center(
                            child: Column(children: [
                          const SizedBox(height: 10),
                          inputDividerWithHeadline('Antall'),
                          inputRow('Sauer & lam', _textControllers['sheep']!,
                              RpgAwesome.sheep, Colors.grey),
                          inputFieldSpacer(),
                          inputRow('Lam', _textControllers['lambs']!,
                              RpgAwesome.sheep, Colors.grey,
                              iconSize: 24),
                          inputFieldSpacer(),
                          inputRow('Hvite', _textControllers['white']!,
                              RpgAwesome.sheep, Colors.white,
                              scrollController: scrollController,
                              key: firstHeadlineFieldKeys[0],
                              ownKey: firstHeadlineFieldKeys[0]),
                          inputFieldSpacer(),
                          inputRow('Brune', _textControllers['brown']!,
                              RpgAwesome.sheep, Colors.brown),
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
                              key: firstHeadlineFieldKeys[1]),
                          if (_isShortDistance) inputFieldSpacer(),
                          if (_isShortDistance) ..._shortDistance(),
                          const SizedBox(height: 80),
                        ]))),
                floatingActionButton: !_isLoading && !widget.ongoingDialog.value
                    ? Row(
                        mainAxisAlignment:
                            MediaQuery.of(context).viewInsets.bottom == 0
                                ? MainAxisAlignment.center
                                : MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          if (widget.stt.isAvailable)
                            Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: startDialogButton(() =>
                                    _startDialog(questions, questionContexts))),
                          MediaQuery.of(context).viewInsets.bottom == 0
                              ? const SizedBox(
                                  width: 20,
                                )
                              : const Spacer(),
                          Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child:
                                  completeRegistrationButton(context, register))
                        ],
                      )
                    : null,
                floatingActionButtonLocation:
                    FloatingActionButtonLocation.centerFloat)));
  }
}
