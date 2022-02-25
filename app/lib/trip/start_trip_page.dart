import 'dart:collection';

import 'package:app/utils/constants.dart';
import 'package:app/utils/map_utils.dart';
import 'package:app/utils/styles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

class StartTripPage extends StatefulWidget {
  const StartTripPage({Key? key}) : super(key: key);

  static const String route = 'start-trip';

  @override
  State<StartTripPage> createState() => _StartTripPageState();
}

class _StartTripPageState extends State<StartTripPage>
    with TickerProviderStateMixin {
  _StartTripPageState();

  final List<String> _farmNames = [];
  List<String> _farmIDs = [];
  late String _selectedFarmName;
  Map<String, Map<String, Map<String, double>>> _selectedFarmMaps =
      <String, Map<String, Map<String, double>>>{};
  String _selectedFarmMap = '';

  String _feedbackText = '';
  bool _loadingData = true;

  IconData _mapIcon = Icons.download_for_offline;
  late AnimationController controller = AnimationController(vsync: this);
  bool _downloadingMap = false;
  bool _mapDownloaded = false;

  static const BoxConstraints fieldNameConstraints =
      BoxConstraints(minWidth: 50);
  static const BoxConstraints dropdownConstraints =
      BoxConstraints(minWidth: 175, maxWidth: 175, maxHeight: 50);

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _readFarms();
    });
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
                      Text(
                        'Laster inn...',
                        style: feedbackTextStyle,
                      )
                    ]
                  : _farmNames.isEmpty
                      ? [
                          Text(
                              'Du er ikke registrert som oppsynspersonell hos noen gård. Ta kontakt med sauebonde.',
                              style: feedbackTextStyle)
                        ]
                      : [
                          const SizedBox(height: 20),
                          _farmNameRow(),
                          const SizedBox(height: 15),
                          _farmMapRow(),
                          const SizedBox(height: 15),
                          Text(
                            _feedbackText,
                            style: feedbackTextStyle,
                          ),
                          const SizedBox(height: 15),
                          ElevatedButton(
                            onPressed: () {
                              // TODO: downloadTiles? Går vel bra uten nett dersom kart er nedlastet. Feedbackon error
                            },
                            child: Text(
                              'Start oppsynstur',
                              style: buttonTextStyle,
                            ),
                            style: ButtonStyle(
                                fixedSize: MaterialStateProperty.all(
                                    Size.fromHeight(mainButtonHeight))),
                          )
                        ],
            )));
  }

  Row _farmNameRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
            constraints: fieldNameConstraints,
            child: Text(
              'Gård',
              style: fieldNameTextStyle,
            )),
        const SizedBox(
          width: 20,
        ),
        Container(
            constraints: const BoxConstraints(
                minWidth: 175 + 70, maxWidth: 175 + 70, maxHeight: 50),
            child: Padding(
                padding: const EdgeInsets.only(right: 50),
                child: DropdownButton<String>(
                    value: _selectedFarmName,
                    items: _farmNames
                        .map((String farmName) => DropdownMenuItem<String>(
                            value: farmName,
                            child: Text(farmName, style: dropDownTextStyle)))
                        .toList(),
                    onChanged: (String? newFarmName) {
                      if (_selectedFarmName != newFarmName) {
                        _readFarmMaps(
                            _farmIDs[_farmNames.indexOf(newFarmName!)]);
                        setState(() {
                          _selectedFarmName = newFarmName;
                          _feedbackText = '';
                          _mapDownloaded = false;
                        });
                      }
                    })))
      ],
    );
  }

  Row _farmMapRow() {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Container(
          constraints: fieldNameConstraints,
          child: Text(
            'Kart',
            style: fieldNameTextStyle,
          )),
      const SizedBox(
        width: 20,
      ),
      Container(
          //constraints: dropdownConstraints,
          child: Row(mainAxisSize: MainAxisSize.max, children: [
        Container(
            constraints: dropdownConstraints,
            child: DropdownButton<String>(
              isExpanded: true,
              value: _selectedFarmMap,
              items: _selectedFarmMaps.keys
                  .map((String mapName) => DropdownMenuItem<String>(
                      value: mapName,
                      child: Text(mapName, style: dropDownTextStyle)))
                  .toList(),
              onChanged: (String? newMapName) {
                if (newMapName! != _selectedFarmName) {
                  setState(() {
                    _selectedFarmMap = newMapName;
                    _feedbackText = '';
                    _mapIcon = Icons.download_for_offline;
                    _mapDownloaded = false;
                  });
                }
              },
            )),
        const SizedBox(width: 10),
        Visibility(
            visible: !_downloadingMap,
            child: IconButton(
              iconSize: 32,
              icon: Icon(
                _mapIcon,
                color: _mapDownloaded ? Colors.green : null,
              ),
              onPressed: () {
                if (_mapIcon != Icons.file_download_done) {
                  LatLng northWest = LatLng(
                      _selectedFarmMaps[_selectedFarmMap]!['northWest']![
                          'latitude']!,
                      _selectedFarmMaps[_selectedFarmMap]!['northWest']![
                          'longitude']!);
                  LatLng southEast = LatLng(
                      _selectedFarmMaps[_selectedFarmMap]!['southEast']![
                          'latitude']!,
                      _selectedFarmMaps[_selectedFarmMap]!['southEast']![
                          'longitude']!);
                  setState(() {
                    controller = AnimationController(
                      vsync: this,
                      duration: const Duration(seconds: 2),
                    )..addListener(() {
                        setState(() {});
                      });
                    controller.repeat(reverse: true); // REVERSE
                    _downloadingMap = true;
                    _mapIcon = Icons.downloading;
                    _feedbackText = 'Laster ned kart...';
                  });
                  downloadTiles(northWest, southEast, OfflineZoomLevels.min,
                          OfflineZoomLevels.max)
                      .then((_) => {
                            setState(() {
                              _downloadingMap = false;
                              _mapDownloaded = true;
                              _mapIcon = Icons.file_download_done;
                              //controller.dispose(); TODO
                              //controller.stop(); // ?
                              _feedbackText =
                                  'Kartet \'$_selectedFarmMap\' er nedlastet.';
                            })
                          });
                } else {
                  debugPrint("Jauda");
                }
              },
            )),
        if (_downloadingMap)
          SizedBox(
              height: 48,
              width: 48,
              child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: CircularProgressIndicator(
                      color: Colors.blue, value: controller.value)))
      ])),
    ]);
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

  void _readFarmMaps(String farmId) async {
    CollectionReference farmCollection =
        FirebaseFirestore.instance.collection('farms');
    DocumentReference farmDoc = farmCollection.doc(farmId);

    DocumentSnapshot<Object?> doc = await farmDoc.get();
    LinkedHashMap<String, dynamic>? maps = await doc.get('maps');

    if (maps != null) {
      _selectedFarmMaps = _castMapsFromDynamic(maps);

      setState(() {
        _selectedFarmMap = _selectedFarmMaps.keys.first;
      });
    } else {
      // TODO: Gården har ikke definert noen kart. Ta kontakt med sauebonde.
    }
  }

  void _readFarms() async {
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
            /*LinkedHashMap<String, dynamic>? maps = await doc.get('maps');
            if (maps != null) {
              _selectedFarmMaps = _castMapsFromDynamic(maps);
              debugPrint(_selectedFarmMaps.toString());
            } else {
              // TODO: Gården har ikke definert noen kart. Ta kontakt med sauebonde.
            }*/
          } else {
            // TODO: Dette er en feil, skal ikke være mulig å havne her
          }
        }

        setState(() {
          _selectedFarmName = _farmNames[0];
        });
      }
      setState(() {
        _loadingData = false;
      });
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
