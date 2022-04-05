import 'dart:collection';

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

class StartTripPage extends StatefulWidget {
  const StartTripPage({Key? key}) : super(key: key);

  static const String route = 'start-trip';
  static const IconData downloadedIcon = Icons.download_done;
  static const IconData notDownloadedIcon = Icons.download_for_offline_sharp;

  @override
  State<StartTripPage> createState() => _StartTripPageState();
}

class _StartTripPageState extends State<StartTripPage>
    with TickerProviderStateMixin {
  _StartTripPageState();

  late SpeechToText _speechToText;
  final ValueNotifier<bool> _ongoingDialog = ValueNotifier<bool>(false);

  late List<String> _farmIDs;

  final List<String> _farmNames = [];
  late String _selectedFarmName;
  late Map<String, bool>? _eartags;
  late Map<String, int>? _ties;

  Map<String, Map<String, Map<String, double>>> _selectedFarmMaps = {};
  String _selectedFarmMap = '';
  Map<String, LatLng> mapBounds = {};

  bool _isLoading = true;
  bool _downloadingMap = false;
  bool _mapDownloaded = false;
  bool _noFarmDefined = false;
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
  static const double fieldNameWidth = 50;
  static const double dropdownWidth = 190;

  @override
  void initState() {
    super.initState();

    _animationSetup();

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
              title: const Text('Start oppsynstur'),
              centerTitle: true,
              actions: const [SettingsIconButton()],
            ),
            body: _isLoading
                ? const LoadingData()
                : Column(
                    children: _farmNames.isEmpty
                        ? [NoFarmInfo()]
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
                  )));
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
                    _readFarmMaps(_farmIDs[_farmNames.indexOf(newFarmName!)]);
                    setState(() {
                      _selectedFarmName = newFarmName;
                      _feedbackText = '';
                      _eartagAndTieText = '';
                      updateIcon();
                    });
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
                  color: _mapDownloaded ? Colors.green : null,
                ),
                onPressed: () {
                  if (!_mapDownloaded) {
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
        : StartTripPage.notDownloadedIcon;
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
          backgroundColor:
              MaterialStateProperty.all(_noMapsDefined ? Colors.grey : null)),
      onPressed: () async {
        if (!_noMapsDefined) {
          _startTrip();
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

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ValueListenableBuilder<bool>(
                valueListenable: _ongoingDialog,
                builder: (context, value, child) => MainPage(
                      speechToText: _speechToText,
                      ongoingDialog: _ongoingDialog,
                      northWest: mapBounds['northWest']!,
                      southEast: mapBounds['southEast']!,
                      farmId: _farmIDs[_farmNames.indexOf(_selectedFarmName)],
                      personnelEmail: FirebaseAuth.instance.currentUser!.email!,
                      mapName:
                          _selectedFarmMap, //TODO change to mapId when maps are their own documents
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

  Future<void> _readFarmMaps(String farmId) async {
    CollectionReference farmCollection =
        FirebaseFirestore.instance.collection('farms');
    DocumentReference farmDoc = farmCollection.doc(farmId);

    DocumentSnapshot<Object?> doc = await farmDoc.get();
    LinkedHashMap<String, dynamic>? dbMaps = await doc.get('maps');
    LinkedHashMap<String, dynamic>? dbEartags = await doc.get('eartags');
    LinkedHashMap<String, dynamic>? dbTies = await doc.get('ties');

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
    String email = FirebaseAuth.instance.currentUser!.email!;
    QuerySnapshot personnelQuerySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: email)
        .get();
    QueryDocumentSnapshot personnelDoc = personnelQuerySnapshot.docs.first;

    List<dynamic> farmIDs = personnelDoc['personnelAtFarms'];
    _farmIDs = farmIDs.map((dynamic id) => id as String).toList();

    CollectionReference farmCollection =
        FirebaseFirestore.instance.collection('farms');
    DocumentReference farmDoc;

    for (int i = 0; i < farmIDs.length; i++) {
      farmDoc = farmCollection.doc(farmIDs[i]);

      DocumentSnapshot<Object?> doc = await farmDoc.get();
      if (doc.exists) {
        _farmNames.add(doc.get('name'));
        if (i == 0) {
          _readFarmMaps(_farmIDs.first);
        }
      }
    }
    if (_farmNames.isNotEmpty) {
      setState(() {
        _selectedFarmName = _farmNames[0];
      });
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
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
                  'Du er ikke registrert som oppsynsperson,\nta kontakt med sauebonde.',
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
                  '1: Logg inn på web-løsning med samme bruker.\n2: Lagre gårdsinformasjon på \'Min side\'.\n3: Logg inn i appen og start oppsynstur.',
                  style: TextStyle(fontSize: 16)))),
    ]);
  }
}
