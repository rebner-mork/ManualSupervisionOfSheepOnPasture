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
  late String _selectedFarm;

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
                                  value: _selectedFarm,
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
                                    setState(() {
                                      _selectedFarm = newString!;
                                      _feedbackText = '';
                                    });
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

  void _readFarms() async {
    String email = FirebaseAuth.instance.currentUser!.email!;
    CollectionReference personnelCollection =
        FirebaseFirestore.instance.collection('personnel');
    DocumentReference personnelDoc = personnelCollection.doc(email);

    List<dynamic> farmIDs;

    DocumentSnapshot<Object?> doc = await personnelDoc.get();
    if (doc.exists) {
      farmIDs = doc.get('farms');
      debugPrint("HER: " + farmIDs.toString());

      CollectionReference farmCollection =
          FirebaseFirestore.instance.collection('farms');
      DocumentReference farmDoc;

      for (dynamic farmId in farmIDs) {
        farmDoc = farmCollection.doc(farmId);

        DocumentSnapshot<Object?> doc = await farmDoc.get();
        if (doc.exists) {
          _farmNames.add(doc.get('name'));
        } else {
          // TODO: Dette er en feil, skal ikke være mulig å havne her
        }
      }

      // TODO: les inn kart til første

      setState(() {
        _selectedFarm = _farmNames[0];
      });
    }
    setState(() {
      _loadingData = false;
    });
  }
}
