import 'dart:collection';

import 'package:app/map/map_widget.dart';
import 'package:app/utils/constants.dart';
import 'package:app/utils/custom_widgets.dart';
import 'package:app/utils/map_utils.dart';
import 'package:app/utils/styles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import 'dart:developer' as dev;

class StartTripPage extends StatefulWidget {
  const StartTripPage({Key? key}) : super(key: key);

  static const String route = 'start-trip';

  @override
  State<StartTripPage> createState() => _StartTripPageState();
}

class _StartTripPageState extends State<StartTripPage>
    with TickerProviderStateMixin {
  _StartTripPageState();

  late List<String> _farmIDs;

  final List<String> _farmNames = [];
  late String _selectedFarmName;

  Map<String, Map<String, Map<String, double>>> _selectedFarmMaps = {};
  String _selectedFarmMap = '';
  Map<String, LatLng> mapBounds = {};

  bool _loadingData = true;
  bool _downloadingMap = false;
  bool _mapDownloaded = false;
  bool _noMapsDefined = false;

  double _downloadProgress = 0.0;

  String _feedbackText = '';

  final IconData downloadedIcon = Icons.download_done;
  final IconData notDownloadedIcon = Icons.download_for_offline_sharp;
  IconData _mapIcon = Icons.download_for_offline_sharp;
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
      _readFarms();
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
            ),
            body: Column(
              children: _loadingData
                  ? [
                      appbarBodySpacer(),
                      Center(
                          child: Text(
                        'Laster inn...',
                        style: feedbackTextStyle,
                      ))
                    ]
                  : _farmNames.isEmpty
                      ? [
                          Text(
                              'Du er ikke registrert som oppsynspersonell hos noen gård. Ta kontakt med sauebonde.',
                              style: feedbackTextStyle)
                        ]
                      : [
                          appbarBodySpacer(),
                          _farmNameRow(),
                          inputFieldSpacer(),
                          _farmMapRow(),
                          inputFieldSpacer(),
                          Text(
                            _feedbackText,
                            style: feedbackTextStyle,
                          ),
                          inputFieldSpacer(),
                          Visibility(
                              visible: _downloadingMap,
                              child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 40),
                                  child: LinearProgressIndicator(
                                    value: _downloadProgress,
                                    //backgroundColor: Colors.grey,
                                    minHeight: 10,
                                  ))),
                          inputFieldSpacer(),
                          startTripButton()
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
                    _readFarmMaps(_farmIDs[_farmNames.indexOf(newFarmName!)]);
                    setState(() {
                      _selectedFarmName = newFarmName;
                      _feedbackText = '';
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
                  if (_mapIcon != downloadedIcon) {
                    setState(() {
                      _animationController.repeat();
                      _downloadingMap = true;
                      _mapIcon = Icons.downloading;
                      _feedbackText = 'Laster ned kart...';
                    });
                    dev.log(mapBounds.toString());
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
                            _mapIcon = downloadedIcon;
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
    dev.log(mapBounds.toString());
  }

  void updateIcon() {
    setMapBounds();
    _mapDownloaded = isTilesDownloaded(mapBounds['northWest']!,
        mapBounds['southEast']!, OfflineZoomLevels.min, OfflineZoomLevels.max);
    _mapIcon = _mapDownloaded ? downloadedIcon : notDownloadedIcon;
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
      updateIcon();
      _downloadingMap = false;
    });
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) =>
                MapWidget(mapBounds['northWest']!, mapBounds['southEast']!)));
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
    LinkedHashMap<String, dynamic>? maps = await doc.get('maps');

    if (maps != null) {
      _selectedFarmMaps = _castMapsFromDynamic(maps);

      setState(() {
        _selectedFarmMap = _selectedFarmMaps.keys.first;
        updateIcon();
      });
    } else {
      setState(() {
        _noMapsDefined = true;
        _selectedFarmMap = '';
        _feedbackText =
            'Gården \'$_selectedFarmName\' har ikke definert noen kart';
      });
    }
  }

  Future<void> _readFarms() async {
    String email = FirebaseAuth.instance.currentUser!.email!;
    CollectionReference personnelCollection =
        FirebaseFirestore.instance.collection('personnel');
    DocumentReference personnelDoc = personnelCollection.doc(email);

    DocumentSnapshot<Object?> doc = await personnelDoc.get();
    if (doc.exists) {
      List<dynamic> farmIDs = doc.get('farms');
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
        } else {
          throw Exception(
              'Firestore: Farm with id ${farmIDs[i]} found in a Personnel-document, but does not exist in the Farms-collection.');
        }

        setState(() {
          _selectedFarmName = _farmNames[0];
        });
      }
    }
    setState(() {
      _loadingData = false;
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
