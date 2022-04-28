import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'dart:async';

import 'package:app/main_page.dart';
import 'package:app/providers/settings_provider.dart';
import 'package:app/utils/constants.dart';
import 'package:app/utils/custom_widgets.dart';
import 'package:app/utils/map_utils.dart';
import 'package:app/utils/styles.dart';
import 'package:app/widgets/circular_buttons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'trip_data_manager.dart';
import '../utils/other.dart';

class StartTripPage extends StatefulWidget {
  const StartTripPage({Key? key, this.isConnected = true}) : super(key: key);

  static const String route = 'start-trip';
  final bool isConnected;

  static const IconData downloadedIcon = Icons.download_done;
  static const IconData notDownloadedIcon = Icons.download_for_offline_sharp;

  @override
  State<StartTripPage> createState() => _StartTripPageState();
}

class _StartTripPageState extends State<StartTripPage>
    with TickerProviderStateMixin {
  _StartTripPageState();

  final Map<String, dynamic> _syncStatus = {
    'text': "Laster...",
    'color': Colors.grey
  };

  late SpeechToText _speechToText;
  final ValueNotifier<bool> _ongoingDialog = ValueNotifier<bool>(false);

  List<Map<String, dynamic>> _farmDocs = [];

  final List<String> _farmNames = [];
  late String _selectedFarmName;
  late String _farmNumber;
  late Map<String, bool>? _eartags;
  late Map<String, int>? _ties;

  Map<String, Map<String, Map<String, double>>> _selectedFarmMaps = {};
  String _selectedFarmMap = '';
  Map<String, LatLng> mapBounds = {};

  bool _isLoading = true;
  bool _downloadingMap = false;
  bool _mapDownloaded = false;
  bool _noMapsDefined = false;
  bool _noEartagsDefined = false;
  bool _noTiesDefined = false;

  double _downloadProgress = 0.0;

  String _feedbackText = '';
  String _eartagAndTieText = '';

  IconData _mapIcon = StartTripPage.notDownloadedIcon;
  late AnimationController _animationController;
  late Animation<Color?> _colorTween;

  static const double downloadIconSize = 48;
  static const double fieldNameWidth = 60;
  static const double dropdownWidth = 190;

  late Timer synchronizeTimer;

  @override
  void initState() {
    super.initState();

    _animationSetup();

    synchronizeTimer =
        Timer.periodic(const Duration(seconds: 15), (_) => trySynchronize());

    Directory(applicationDocumentDirectoryPath + "/trips").createSync();
    trySynchronize();

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _initSpeechToText();
      _readFarms();
    });
  }

  void _initSpeechToText() async {
    _speechToText = SpeechToText();
    await _speechToText.initialize(onError: _speechToTextError);
    Provider.of<SettingsProvider>(context, listen: false)
        .setSttAvailability(_speechToText.isAvailable);
  }

  void _speechToTextError(SpeechRecognitionError error) {
    setState(() {
      _ongoingDialog.value = false;
    });
  }

  void _animationSetup() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..addListener(() {
        setState(() {});
      });
    _animationController.reset();

    _colorTween = _animationController.drive(
        ColorTween(begin: Colors.green.shade700, end: Colors.green.shade300));
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        child: Scaffold(
            appBar: AppBar(
              title: Text(widget.isConnected
                  ? 'Start oppsynstur'
                  : 'Start oppsynstur offline'),
              actions: const [SettingsIconButton()],
            ),
            body: Stack(children: [
              _isLoading
                  ? const LoadingData()
                  : Column(
                      children: _farmNames.isEmpty
                          ? [
                              widget.isConnected
                                  ? const NoFarmInfo()
                                  : const NoFarmNoInternetInfo()
                            ]
                          : [
                              appbarBodySpacer(),
                              _farmNameRow(),
                              inputFieldSpacer(),
                              if (!_noMapsDefined) _farmMapRow(),
                              if (!_noMapsDefined) inputFieldSpacer(),
                              Text(
                                _feedbackText,
                                style: _noMapsDefined
                                    ? feedbackErrorTextStyle
                                    : feedbackTextStyle,
                              ),
                              inputFieldSpacer(),
                              Visibility(
                                  visible: _downloadingMap,
                                  child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 40),
                                      child: LinearProgressIndicator(
                                        value: _downloadProgress,
                                        minHeight: 10,
                                      ))),
                              inputFieldSpacer(),
                              startTripButton(),
                              inputFieldSpacer(),
                              Text(_eartagAndTieText, style: feedbackTextStyle),
                            ],
                    ),
              Positioned(
                  bottom: MediaQuery.of(context).viewPadding.bottom,
                  child: Container(
                      color: _syncStatus['color'],
                      height: 20,
                      width: MediaQuery.of(context).size.width,
                      child: Center(
                          child: Text(
                        _syncStatus['text'],
                        style: const TextStyle(color: Colors.white),
                      ))))
            ])));
  }

  Row _farmNameRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
            width: fieldNameWidth,
            child: Text(
              'Gård',
              style: fieldNameTextStyle,
              textAlign: TextAlign.end,
            )),
        const SizedBox(
          width: 20,
        ),
        SizedBox(
            width: dropdownWidth,
            child: DropdownButton<String>(
                isExpanded: true,
                value: _selectedFarmName,
                items: _farmNames
                    .map((String farmName) => DropdownMenuItem<String>(
                        value: farmName,
                        child: Text(farmName, style: dropDownTextStyle)))
                    .toList(),
                onChanged: (String? newFarmName) {
                  if (_selectedFarmName != newFarmName) {
                    _noMapsDefined = false;
                    _noEartagsDefined = false;
                    _noTiesDefined = false;
                    setState(() {
                      _selectedFarmName = newFarmName!;
                      _feedbackText = '';
                      _eartagAndTieText = '';
                    });
                    _readFarmMaps(_farmDocs[_farmNames.indexOf(newFarmName!)]);
                  }
                })),
        // To fill space of download-icon in _farmMapRow (+ 10 from SizedBox)
        const SizedBox(
          width: downloadIconSize + 10,
        )
      ],
    );
  }

  Row _farmMapRow() {
    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
              width: fieldNameWidth,
              child: Text(
                'Kart',
                style: fieldNameTextStyle,
                textAlign: TextAlign.right,
              )),
          const SizedBox(
            width: 20,
          ),
          SizedBox(
              width: dropdownWidth,
              child: DropdownButton<String>(
                isExpanded: true,
                value: _selectedFarmMap,
                items: _selectedFarmMaps.keys
                    .map((String mapName) => DropdownMenuItem<String>(
                        value: mapName,
                        child: Text(mapName, style: dropDownTextStyle)))
                    .toList(),
                onChanged: (String? newMapName) {
                  if (newMapName! != _selectedFarmMap) {
                    setState(() {
                      _selectedFarmMap = newMapName;
                      _feedbackText = '';
                      updateIcon();
                    });
                  }
                },
              )),
          const SizedBox(width: 10),
          Visibility(
              visible: !_downloadingMap,
              child: IconButton(
                padding: EdgeInsets.zero,
                iconSize: downloadIconSize,
                icon: Icon(
                  _mapIcon,
                  color: _mapDownloaded
                      ? Colors.green
                      : widget.isConnected
                          ? null
                          : Colors.red,
                ),
                onPressed: () {
                  if (widget.isConnected && !_mapDownloaded) {
                    setState(() {
                      _animationController.repeat();
                      _downloadingMap = true;
                      _feedbackText = 'Laster ned kart...';
                    });
                    downloadTiles(
                        mapBounds['northWest']!,
                        mapBounds['southEast']!,
                        OfflineZoomLevels.min,
                        OfflineZoomLevels.max, progressIndicator: (value) {
                      _downloadProgress = value;
                    }).then((_) => {
                          setState(() {
                            _downloadingMap = false;
                            _mapDownloaded = true;
                            _mapIcon = StartTripPage.downloadedIcon;
                            _downloadProgress = 0;
                            _animationController.reset();
                            _feedbackText =
                                'Kartet \'$_selectedFarmMap\' er nedlastet.';
                          })
                        });
                  }
                },
              )),
          if (_downloadingMap)
            SizedBox(
                height: downloadIconSize,
                width: downloadIconSize,
                child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: CircularProgressIndicator(
                      valueColor: _colorTween,
                      strokeWidth: 5,
                    ))),
        ]);
  }

  void setMapBounds() {
    mapBounds['northWest'] = LatLng(
        _selectedFarmMaps[_selectedFarmMap]!['northWest']!['latitude']!,
        _selectedFarmMaps[_selectedFarmMap]!['northWest']!['longitude']!);
    mapBounds['southEast'] = LatLng(
        _selectedFarmMaps[_selectedFarmMap]!['southEast']!['latitude']!,
        _selectedFarmMaps[_selectedFarmMap]!['southEast']!['longitude']!);
  }

  void updateIcon() {
    setMapBounds();
    _mapDownloaded = isEveryTileDownloaded(mapBounds['northWest']!,
        mapBounds['southEast']!, OfflineZoomLevels.min, OfflineZoomLevels.max);
    _mapIcon = _mapDownloaded
        ? StartTripPage.downloadedIcon
        : widget.isConnected
            ? StartTripPage.notDownloadedIcon
            : Icons.clear;
    if (!widget.isConnected && !_mapDownloaded) {
      setState(() {
        _feedbackText =
            'Kan ikke starte oppsynstur,\nvalgt kart er ikke nedlastet';
      });
    }
  }

  ElevatedButton startTripButton() {
    return ElevatedButton(
      child: Text(
        'Start oppsynstur',
        style: buttonTextStyle,
      ),
      style: ButtonStyle(
          fixedSize:
              MaterialStateProperty.all(Size.fromHeight(mainButtonHeight)),
          backgroundColor: MaterialStateProperty.all((_noMapsDefined ||
                  _downloadingMap ||
                  (!widget.isConnected && !_mapDownloaded))
              ? Colors.grey
              : null)),
      onPressed: () async {
        if (!_noMapsDefined) {
          if (widget.isConnected) {
            _startTrip();
          } else {
            if (_mapDownloaded) {
              _startTrip();
            }
          }
        }
      },
    );
  }

  Future<void> _startTrip() async {
    if (!_mapDownloaded) {
      setState(() {
        _feedbackText = 'Oppsynsturen starter når kartet er lastet ned';
        _downloadingMap = true;
      });
      await downloadTiles(
          mapBounds['northWest']!,
          mapBounds['southEast']!,
          OfflineZoomLevels.min,
          OfflineZoomLevels.max, progressIndicator: (value) {
        setState(() {
          _downloadProgress = value;
        });
      });
    }

    setState(() {
      _feedbackText = '';
      _eartagAndTieText = '';
      updateIcon();
      _downloadingMap = false;
      _downloadProgress = 0;
    });
    synchronizeTimer.cancel();
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ValueListenableBuilder<bool>(
                valueListenable: _ongoingDialog,
                builder: (context, value, child) => MainPage(
                      speechToText: _speechToText,
                      ongoingDialog: _ongoingDialog,
                      onCompleted: () {
                        trySynchronize();
                        synchronizeTimer = Timer.periodic(
                            const Duration(seconds: 15),
                            (_) => trySynchronize());
                      },
                      northWest: mapBounds['northWest']!,
                      southEast: mapBounds['southEast']!,
                      farmId: _farmDocs[_farmNames.indexOf(_selectedFarmName)]
                          ['farmId'],
                      personnelEmail: FirebaseAuth.instance.currentUser!.email!,
                      mapName: _selectedFarmMap,
                      farmNumber: _farmNumber,
                      eartags: _noEartagsDefined
                          ? possibleEartagsWithoutDefinition
                          : _eartags!,
                      ties: _noTiesDefined
                          ? possibleTiesWithoutDefinition
                          : _ties!,
                    ))));
  }

  Map<String, Map<String, Map<String, double>>> _castMapsFromDynamic(
      LinkedHashMap<String, dynamic>? maps) {
    return maps!
        .map((key, value) => MapEntry(key, value as Map<String, dynamic>))
        .map((key, value) => MapEntry(
            key,
            value
                .map((key, value) =>
                    MapEntry(key, value as Map<String, dynamic>))
                .map((key, value) => MapEntry(
                    key,
                    value.map(
                        (key, value) => MapEntry(key, value as double))))));
  }

  Future<void> _readFarmMaps(Map<String, dynamic> farmDoc) async {
    LinkedHashMap<String, dynamic>? dbMaps = farmDoc['maps'];
    LinkedHashMap<String, dynamic>? dbEartags = farmDoc['eartags'];
    LinkedHashMap<String, dynamic>? dbTies = farmDoc['ties'];

    if (dbMaps != null && dbMaps.isNotEmpty) {
      _selectedFarmMaps = _castMapsFromDynamic(dbMaps);

      setState(() {
        _selectedFarmMap = _selectedFarmMaps.keys.first;
        updateIcon();
      });
    } else {
      setState(() {
        _noMapsDefined = true;
        _feedbackText += 'Gården har ikke definert noen kart,\n'
            'oppsynstur kan dermed ikke starte.';
      });
    }

    _farmNumber = farmDoc['farmNumber'] ?? '';

    if (dbEartags != null && dbEartags.isNotEmpty) {
      _eartags = dbEartags.map((key, value) => MapEntry(key, value as bool));
    } else {
      _noEartagsDefined = true;
    }

    if (dbTies != null && dbTies.isNotEmpty) {
      _ties = dbTies.map((key, value) => MapEntry(key, value as int));
    } else {
      _noTiesDefined = true;
    }

    if (_noTiesDefined && _noEartagsDefined) {
      setState(() {
        _eartagAndTieText = 'Gården har ikke definert slips eller øremerker, \n'
            'registrering vil dermed vise alle farger.';
      });
    } else if (_noTiesDefined && !_noEartagsDefined) {
      setState(() {
        _eartagAndTieText += 'Gården har ikke definert slips,\n'
            'registrering vil vise alle øremerkefarger.\n';
      });
    } else if (!_noTiesDefined && _noEartagsDefined) {
      setState(() {
        _eartagAndTieText += 'Gården har ikke definert øremerker,\n'
            'registrering vil vise alle øremerkefarger.\n';
      });
    }
  }

  Future<void> _readFarms() async {
    if (widget.isConnected) {
      QuerySnapshot farmsSnapshot = await FirebaseFirestore.instance
          .collection('farms')
          .where('personnel',
              arrayContains: FirebaseAuth.instance.currentUser!.email)
          .get();

      _farmDocs = farmsSnapshot.docs.map((QueryDocumentSnapshot farmDoc) {
        Map<String, dynamic> farmMap = farmDoc.data() as Map<String, dynamic>;
        farmMap.addAll({'farmId': farmDoc.id});
        return farmMap;
      }).toList();

      try {
        await File(offlineFarmsFilePath).delete();
      } on FileSystemException catch (_) {}
    } else {
      try {
        _farmDocs =
            (json.decode(File(offlineFarmsFilePath).readAsStringSync()) as List)
                .map((e) => e as Map<String, dynamic>)
                .toList();
      } on FileSystemException catch (_) {}
    }

    List<Object> offlineFarmData = [];
    Map<String, dynamic> offlineFarmElement;

    if (_farmDocs.isNotEmpty) {
      for (int i = 0; i < _farmDocs.length; i++) {
        _farmNames.add(_farmDocs[i]['name']);

        if (widget.isConnected) {
          offlineFarmElement = _farmDocs[i];
          offlineFarmElement.remove('personnel');
          offlineFarmData.add(offlineFarmElement);
        }

        if (i == 0) {
          _readFarmMaps(_farmDocs.first);
        }
      }

      if (widget.isConnected) {
        File(offlineFarmsFilePath)
            .writeAsStringSync(json.encode(offlineFarmData));
      }

      if (_farmNames.isNotEmpty) {
        setState(() {
          _selectedFarmName = _farmNames[0];
        });
      }
    }

    setState(() {
      _isLoading = false;
    });
  }

  void synchronize() {
    setState(() {
      _syncStatus['color'] = Colors.orange;
      _syncStatus['text'] = "Synkroniserer...";
    });

    List<FileSystemEntity> files =
        Directory(applicationDocumentDirectoryPath + "/trips")
            .listSync(recursive: false);

    for (FileSystemEntity file in files) {
      String json = File(file.path).readAsStringSync();
      TripDataManager trip = TripDataManager.fromJson(json);
      trip.post();
      File(file.path).delete();
    }
    setState(() {
      _syncStatus['color'] = Colors.green;
      _syncStatus['text'] = "Synkronisert";
    });
  }

  bool isSynchronized() {
    List<FileSystemEntity> files =
        Directory(applicationDocumentDirectoryPath + "/trips")
            .listSync(recursive: false);

    if (files.isNotEmpty) {
      return false;
    }

    synchronizeTimer.cancel();
    return true;
  }

  Future<void> trySynchronize() async {
    if (isSynchronized()) {
      setState(() {
        _syncStatus['color'] = Colors.green;
        _syncStatus['text'] = "Synkronisert";
      });
    } else {
      bool connected = await isConnectedToInternet();
      if (connected) {
        synchronize();
      } else {
        setState(() {
          _syncStatus['color'] = Colors.red;
          _syncStatus['text'] = "Ikke synkronisert";
        });
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    synchronizeTimer.cancel();
    super.dispose();
  }
}

class NoFarmInfo extends StatelessWidget {
  const NoFarmInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      appbarBodySpacer(),
      const Text('Kan ikke starte oppsynstur', style: TextStyle(fontSize: 26)),
      const SizedBox(height: 40),
      const Align(
          alignment: Alignment.centerLeft,
          child: Padding(
              padding: EdgeInsets.only(left: 15),
              child: Text('Skal du gå for noen andres gård?',
                  style: TextStyle(fontSize: 22)))),
      const SizedBox(height: 10),
      const Align(
          alignment: Alignment.centerLeft,
          child: Padding(
              padding: EdgeInsets.only(left: 25),
              child: Text(
                  'Du er ikke registrert som oppsynsperson,\n'
                  'ta kontakt med sauebonde.',
                  style: TextStyle(fontSize: 16)))),
      const SizedBox(height: 30),
      const Align(
          alignment: Alignment.centerLeft,
          child: Padding(
              padding: EdgeInsets.only(left: 15),
              child: Text('Skal du gå for din egen gård?',
                  style: TextStyle(fontSize: 22)))),
      const SizedBox(height: 10),
      const Align(
          alignment: Alignment.centerLeft,
          child: Padding(
              padding: EdgeInsets.only(left: 25),
              child: Text(
                  '1: Logg inn på web-løsning med samme bruker.\n'
                  '2: Lagre gårdsinformasjon på \'Min side\'.\n'
                  '3: Logg inn i appen og start oppsynstur.',
                  style: TextStyle(fontSize: 16)))),
    ]);
  }
}

class NoFarmNoInternetInfo extends StatelessWidget {
  const NoFarmNoInternetInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      appbarBodySpacer(),
      const Text('Kan ikke starte oppsynstur', style: TextStyle(fontSize: 26)),
      const SizedBox(height: 40),
      const Align(
          alignment: Alignment.centerLeft,
          child: Padding(
              padding: EdgeInsets.only(left: 15),
              child: Text('Ingen nettverksforbindelse',
                  style: TextStyle(fontSize: 22)))),
      const SizedBox(height: 10),
      const Align(
          alignment: Alignment.centerLeft,
          child: Padding(
              padding: EdgeInsets.only(left: 25),
              child: Text(
                  'Det ligger ingen gårdsinfo lokalt på enheten.\n'
                  'For å gjøre oppsyn uten internett må du først\n'
                  'logge inn med nettverksforbindelse, og laste\n'
                  'ned kartet du skal gå i.',
                  style: TextStyle(fontSize: 16)))),
    ]);
  }
}
