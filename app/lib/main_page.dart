import 'dart:async';

import 'package:app/map/map_widget.dart';
import 'package:app/registration_options.dart';
import 'package:app/trip/end_trip_dialog.dart';
import 'package:app/trip/start_trip_page.dart';
import 'package:app/trip/trip_data_manager.dart';
import 'package:app/utils/constants.dart';
import 'package:app/utils/custom_widgets.dart';
import 'package:app/utils/other.dart';
import 'package:app/widgets/circular_buttons.dart';

import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:speech_to_text/speech_to_text.dart';
import '../utils/map_utils.dart' as map_utils;

class MainPage extends StatefulWidget {
  const MainPage(
      {required this.speechToText,
      required this.ongoingDialog,
      required this.northWest,
      required this.southEast,
      required this.mapName,
      required this.farmId,
      required this.personnelEmail,
      required this.eartags,
      required this.ties,
      Key? key})
      : super(key: key);

  final SpeechToText speechToText;
  final ValueNotifier<bool> ongoingDialog;

  final LatLng northWest;
  final LatLng southEast;

  final String mapName;

  final String farmId;
  final String personnelEmail;

  final Map<String, bool?> eartags;
  final Map<String, int?> ties;

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  static const double buttonInset = 8;
  late final TripDataManager _tripData;

  late LatLng _deviceStartPosition;

  int _sheepAmount = 0;
  double iconSize = 42;
  bool _isLoading = true;

  bool _inSelectPositionMode = false;
  RegistrationType _selectedRegistrationType = RegistrationType.sheep;
  Timer? _selectPositionTextTimer;
  int selectPositionTextTimerDuration = 1200; // ms
  bool _isSelectPositionTextVisible = true;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _setDeviceStartPosition();
    });
  }

  Future<void> _setDeviceStartPosition() async {
    _deviceStartPosition = await map_utils.getDevicePosition();

    _tripData = TripDataManager.start(
        personnelEmail: widget.personnelEmail,
        farmId: widget.farmId,
        mapName: widget.mapName);
    _tripData.track.add(_deviceStartPosition);

    setState(() {
      _isLoading = false;
    });
  }

  void _startSelectPositionTextTimer() {
    _isSelectPositionTextVisible = true;
    _selectPositionTextTimer = Timer.periodic(
        Duration(milliseconds: selectPositionTextTimerDuration), (timer) {
      setState(() {
        _isSelectPositionTextVisible = !_isSelectPositionTextVisible;
      });
    });
  }

  Future<bool> _backButtonPressed(BuildContext context) async {
    if (_inSelectPositionMode) {
      _cancelSelectPositionMode();
      return false;
    } else {
      await showEndTripDialog(context).then((isFinished) {
        if (isFinished) {
          _tripData.post();
          Navigator.popUntil(context, ModalRoute.withName(StartTripPage.route));
        }
        return isFinished;
      });
      return false;
    }
  }

  void _cancelSelectPositionMode() {
    setState(() {
      _inSelectPositionMode = false;
      _selectedRegistrationType = RegistrationType.sheep;
      if (_selectPositionTextTimer != null) {
        _selectPositionTextTimer!.cancel();
      }
    });
  }

  @override
  void dispose() {
    if (_selectPositionTextTimer != null) {
      _selectPositionTextTimer!.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        child: _isLoading
            ? const LoadingData()
            : WillPopScope(
                onWillPop: () async {
                  return _backButtonPressed(context);
                },
                child: Scaffold(
                    endDrawer: Align(
                        alignment: Alignment.bottomRight,
                        child: Padding(
                            padding: EdgeInsets.only(
                                bottom:
                                    MediaQuery.of(context).viewPadding.bottom +
                                        50 + // height of CircularButton
                                        2 * buttonInset),
                            child: ClipRRect(
                                borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(30),
                                    bottomLeft: Radius.circular(30)),
                                child: SizedBox(
                                    width: 280,
                                    height: 520,
                                    child: Drawer(
                                      child: RegistrationOptions(
                                          ties: widget.ties,
                                          onRegisterOptionSelected:
                                              (RegistrationType type) {
                                            setState(() {
                                              _inSelectPositionMode = true;
                                              _selectedRegistrationType = type;
                                              _startSelectPositionTextTimer();
                                            });
                                          }),
                                    ))))),
                    body: Stack(children: [
                      ValueListenableBuilder<bool>(
                          valueListenable: widget.ongoingDialog,
                          builder: (context, value, child) => MapWidget(
                                northWest: widget.northWest,
                                southEast: widget.southEast,
                                stt: widget.speechToText,
                                ongoingDialog: widget.ongoingDialog,
                                eartags: widget.eartags,
                                ties: widget.ties,
                                deviceStartPosition: _deviceStartPosition,
                                registrationType: _selectedRegistrationType,
                                onRegistrationCanceled:
                                    _cancelSelectPositionMode,
                                onRegistrationComplete:
                                    (Map<String, Object> data) {
                                  switch (_selectedRegistrationType) {
                                    case RegistrationType.sheep:
                                      int sheepAmountRegistered =
                                          data['sheep']! as int;
                                      if (sheepAmountRegistered > 0) {
                                        _tripData.registrations.add(data);
                                        setState(() {
                                          _sheepAmount += sheepAmountRegistered;
                                        });
                                      }
                                      break;
                                    case RegistrationType.injury:
                                      _tripData.registrations.add(data);
                                      setState(() {
                                        _sheepAmount += 1;
                                      });
                                      break;
                                    case RegistrationType.cadaver:
                                      _tripData.registrations.add(data);
                                      break;
                                    default: // TODO: remove default when all types are added
                                      break;
                                  }

                                  _cancelSelectPositionMode();
                                },
                              )),
                      if (_inSelectPositionMode)
                        Padding(
                          padding: EdgeInsets.only(
                              top: buttonInset +
                                  MediaQuery.of(context).viewPadding.top,
                              left: buttonInset,
                              right: 20),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CircularButton(
                                    child: Icon(Icons.cancel, size: iconSize),
                                    onPressed: () {
                                      _cancelSelectPositionMode();
                                    }),
                                Expanded(
                                    child: AnimatedOpacity(
                                        opacity: _isSelectPositionTextVisible
                                            ? 1.0
                                            : 0.3,
                                        duration: Duration(
                                            milliseconds:
                                                selectPositionTextTimerDuration),
                                        child: Text(
                                          'Hold inne på posisjonen til ${registrationTypeToGui[_selectedRegistrationType]}',
                                          style: const TextStyle(fontSize: 26),
                                          textAlign: TextAlign.center,
                                        )))
                              ]),
                        ),
                      if (!_inSelectPositionMode)
                        Positioned(
                          top: buttonInset +
                              MediaQuery.of(context).viewPadding.top,
                          left: buttonInset,
                          child: CircularButton(
                              child: Icon(
                                Icons.cloud_upload,
                                size: iconSize,
                              ),
                              onPressed: () {
                                _backButtonPressed(context);
                              }),
                        ),
                      if (!_inSelectPositionMode)
                        Positioned(
                            top: buttonInset +
                                MediaQuery.of(context).viewPadding.top,
                            right: buttonInset,
                            child: CircularButton(
                              child: SettingsIcon(iconSize: iconSize),
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (_) => const SettingsDialog());
                              },
                            )),
                      if (!_inSelectPositionMode)
                        Positioned(
                          bottom: buttonInset +
                              MediaQuery.of(context).viewPadding.bottom,
                          left: buttonInset,
                          child: CircularButton(
                            child: Sheepometer(
                                sheepAmount: _sheepAmount, iconSize: iconSize),
                            onPressed: () {},
                            width: 62 +
                                textSize(_sheepAmount.toString(),
                                        circularButtonTextStyle)
                                    .width,
                          ),
                        ),
                      if (!_inSelectPositionMode)
                        Builder(
                            builder: (context) => Positioned(
                                bottom: buttonInset +
                                    MediaQuery.of(context).viewPadding.bottom,
                                right: buttonInset,
                                child: CircularButton(
                                  child: const Text(
                                    '+?',
                                    style: TextStyle(
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  onPressed: () {
                                    Scaffold.of(context).openEndDrawer();
                                  },
                                )))
                    ]))));
  }
}
