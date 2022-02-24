import 'dart:collection';

import 'package:app/utils/styles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class StartTripPage extends StatefulWidget {
  const StartTripPage({Key? key}) : super(key: key);

  static const String route = 'start-trip';

  @override
  State<StartTripPage> createState() => _StartTripPageState();
}

class _StartTripPageState extends State<StartTripPage> {
  _StartTripPageState();

  final List<String> _farmNames = [];
  List<String> _farmIDs = [];
  late String _selectedFarmName;
  Map _selectedFarmMaps = <String, Map<String, Map<String, double>>>{};

  String _feedbackText = '';
  bool _loadingData = true;

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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Gård',
                                style: fieldNameTextStyle,
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              DropdownButton<String>(
                                  value: _selectedFarmName,
                                  items: _farmNames
                                      .map((String farmName) =>
                                          DropdownMenuItem<String>(
                                              value: farmName,
                                              child: Text(
                                                farmName,
                                                style: dropDownTextStyle,
                                              )))
                                      .toList(),
                                  onChanged: (String? newString) {
                                    // TODO: hvis ulik, les inn kart
                                    if (_selectedFarmName != newString) {
                                      _readFarmMaps(_farmIDs[
                                          _farmNames.indexOf(newString!)]);
                                      setState(() {
                                        _selectedFarmName = newString;
                                        _feedbackText = '';
                                      });
                                    }
                                  })
                            ],
                          ),
                          const SizedBox(height: 15),
                          ElevatedButton(
                            onPressed: () {
                              /*setState(() {
                            if (_selectedFarm == '') {
                              _feedbackText = 'Gård må velges før kart';
                            }
                          });*/
                            },
                            child: Text(
                              'Velg kart',
                              style: buttonTextStyle,
                            ),
                            style: ButtonStyle(
                                fixedSize: MaterialStateProperty.all(
                                    Size.fromHeight(buttonHeight))
                                /*backgroundColor: MaterialStateProperty.all(
                                _selectedFarm == ''
                                    ? buttonDisabledColor
                                    : buttonEnabledColor)*/
                                ),
                          ),
                          const SizedBox(height: 15),
                          Text(
                            _feedbackText,
                            style: feedbackTextStyle,
                          ),
                          const SizedBox(height: 15),
                          ElevatedButton(
                            onPressed: () {
                              // TODO: feedback if map not selected
                              /*if (_selectedFarm == '') {
                            setState(() {
                              _feedbackText = 'Gård må velges';
                            });
                          }*/
                            },
                            child: Text(
                              'Start oppsynstur',
                              style: buttonTextStyle,
                            ),
                            style: ButtonStyle(
                                fixedSize: MaterialStateProperty.all(
                                    Size.fromHeight(mainButtonHeight))
                                /*backgroundColor: MaterialStateProperty.all(
                                _selectedFarm == ''
                                    ? buttonDisabledColor
                                    : buttonEnabledColor)*/
                                ),
                          )
                        ],
            )));
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
      debugPrint(_selectedFarmMaps.toString());
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
}
