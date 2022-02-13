import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:web/my_page/define_map/define_map.dart';
import 'package:latlong2/latlong.dart';

class DefineMapPage extends StatefulWidget {
  const DefineMapPage({Key? key}) : super(key: key);

  @override
  State<DefineMapPage> createState() => _DefineMapPageState();

  static const String route = 'define-map';
}

class _DefineMapPageState extends State<DefineMapPage> {
  _DefineMapPageState();

  final List<String> _mapNames = ["Bymarka", "Strindamarka"];
  final List<List<LatLng>> _mapCoordinates = [
    [LatLng(10, 10), LatLng(20, 20)],
    [LatLng(20, 20), LatLng(30, 30)]
  ];
  final List<TextEditingController> _mapNameControllers = [];
  final List<bool> _showDeleteIcon = [];

  bool showMap = false;

  late String _newCoordinatesText;
  List<LatLng> _newCoordinates = [];
  TextEditingController _newMapNameController = TextEditingController();

  String _helpText = '';
  static const String helpTextNorthWest =
      "Klikk og hold på kartet for å markere nordvestlig hjørne av beiteområdet";
  static const String helpTextSouthEast =
      "Klikk og hold på kartet for å markere sørøstlig hjørne av beiteområdet";
  static const String helpTextSave =
      "Klikk på lagre-knappen når du har skrevet inn navn på kartområdet";
  static const String coordinatesPlaceholder = "(?, ?), (?, ?)";

  final TextStyle buttonTextStyle = const TextStyle(fontSize: 18);
  final TextStyle columnNameStyle =
      const TextStyle(fontSize: 18, fontWeight: FontWeight.bold);

  @override
  void initState() {
    super.initState();

    //_helpText = helpTextNorthWest;
    _newCoordinatesText = coordinatesPlaceholder;

    for (String mapName in _mapNames) {
      TextEditingController controller = TextEditingController();
      controller.text = mapName;
      _mapNameControllers.add(controller);

      _showDeleteIcon.add(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        child: Column(children: [
      Flexible(
          flex: 2,
          child: SingleChildScrollView(
              child: DataTable(
                  // TODO: Add image of map?
                  border: TableBorder.symmetric(),
                  showCheckboxColumn: false,
                  columns: [
                    DataColumn(
                        label: Text(
                      'Kartnavn',
                      style: columnNameStyle,
                    )),
                    DataColumn(
                        label: Row(children: [
                      Text(
                        'Koordinater',
                        style: columnNameStyle,
                      ),
                      const Text(
                        ' (NV), (NØ)',
                      )
                    ])),
                    const DataColumn(
                      label: Text(''),
                    ),
                  ],
                  rows: _mapNames
                          .asMap()
                          .entries
                          .map((MapEntry<int, String> data) => DataRow(cells: [
                                DataCell(
                                    TextField(
                                      controller: _mapNameControllers[data.key],
                                      onChanged: (name) {
                                        //_mapNames[data.key] = name;
                                        setState(() {
                                          _showDeleteIcon[data.key] = false;
                                        });
                                      },
                                    ),
                                    showEditIcon: true),
                                DataCell(
                                  Text('(' +
                                      _mapCoordinates[data.key][0]
                                          .latitude
                                          .toString() +
                                      ', ' +
                                      _mapCoordinates[data.key][0]
                                          .longitude
                                          .toString() +
                                      ')' +
                                      ', (' +
                                      _mapCoordinates[data.key][1]
                                          .latitude
                                          .toString() +
                                      ', ' +
                                      _mapCoordinates[data.key][1]
                                          .longitude
                                          .toString() +
                                      ')'),
                                ),
                                DataCell(_showDeleteIcon[data.key]
                                    ? IconButton(
                                        icon: Icon(
                                          Icons.delete,
                                          color: Colors.grey.shade800,
                                          size: 26,
                                        ),
                                        splashRadius: 22,
                                        hoverColor: Colors.red,
                                        onPressed: () {
                                          // TODO: sikker?
                                          showDialog(
                                              context: context,
                                              builder: (_) => deleteMapDialog(
                                                  context, data.key));
                                        })
                                    : ElevatedButton(
                                        style: ButtonStyle(
                                            fixedSize:
                                                MaterialStateProperty.all(
                                                    const Size.fromHeight(35))),
                                        child: Text(
                                          "Lagre",
                                          style: buttonTextStyle,
                                        ),
                                        onPressed: () =>
                                            _saveChangedMap(data.key),
                                      ))
                              ]))
                          .toList() +
                      [
                        DataRow(
                            color: showMap
                                ? MaterialStateProperty.all(
                                    Colors.yellow.shade300)
                                : null,
                            cells: [
                              DataCell(showMap
                                  ? TextField(
                                      controller: _newMapNameController,
                                      decoration: const InputDecoration(
                                          hintText: 'Skriv navn'))
                                  : Container()),
                              DataCell(showMap
                                  ? Text(_newCoordinatesText)
                                  : Container()),
                              DataCell(
                                showMap
                                    ? Row(children: [
                                        ElevatedButton(
                                          style: ButtonStyle(
                                              fixedSize:
                                                  MaterialStateProperty.all(
                                                      const Size.fromHeight(
                                                          35))),
                                          child: Text('Lagre',
                                              style: buttonTextStyle),
                                          onPressed: () => _saveNewMap(),
                                        ),
                                        const SizedBox(width: 10),
                                        ElevatedButton(
                                          style: ButtonStyle(
                                              fixedSize:
                                                  MaterialStateProperty.all(
                                                      const Size.fromHeight(
                                                          35)),
                                              textStyle:
                                                  MaterialStateProperty.all(
                                                      buttonTextStyle),
                                              backgroundColor:
                                                  MaterialStateProperty.all(
                                                      Colors.red)),
                                          child: const Text("Avbryt"),
                                          onPressed: () {
                                            setState(() {
                                              showMap = false;
                                              _newCoordinatesText =
                                                  coordinatesPlaceholder;
                                              _newMapNameController.clear();
                                            });
                                          },
                                        )
                                      ])
                                    : ElevatedButton(
                                        style: ButtonStyle(
                                            fixedSize:
                                                MaterialStateProperty.all(
                                                    const Size.fromHeight(35))),
                                        child: Text("Legg til",
                                            style: buttonTextStyle),
                                        onPressed: () {
                                          setState(() {
                                            showMap = true;
                                            _helpText = helpTextNorthWest;
                                          });
                                        },
                                      ),
                              )
                            ])
                      ]))),
      const SizedBox(height: 10),
      (_helpText == helpTextNorthWest || _helpText == helpTextSouthEast)
          ? Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(
                _helpText.substring(0, 14),
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                _helpText.substring(14, 38),
                style: const TextStyle(fontSize: 16),
              ),
              Text(
                _helpText.substring(38, 57),
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                _helpText.substring(57),
                style: const TextStyle(fontSize: 16),
              ),
            ])
          : Text(
              _helpText,
              style: const TextStyle(fontSize: 16),
            ),
      const SizedBox(height: 10),
      if (showMap)
        Flexible(flex: 5, fit: FlexFit.tight, child: DefineMap(_onCornerMarked))
    ]));
  }

  void _onCornerMarked(List<LatLng> points) {
    // TODO: limit map area?
    setState(() {
      if (points.length == 1) {
        _helpText = helpTextSouthEast;
        setState(() {
          _newCoordinatesText =
              '(${points[0].latitude}, ${points[0].longitude})';
        });
      } else {
        setState(() {
          _helpText = helpTextSave;
          _newCoordinatesText =
              '(${points[0].latitude}, ${points[0].longitude}), (${points[1].latitude}, ${points[0].longitude})';
          _newCoordinates = points;
        });
      }
    });
  }

  void _readMapData() async {}

  void _saveMapData() async {
    Map dataMap = <String, Map<String, List<double>>>{};
    for (int i = 0; i < _mapNames.length; i++) {
      dataMap[_mapNames[i]] = <String, List<double>>{
        'nw': [_mapCoordinates[i][0].latitude, _mapCoordinates[i][0].longitude],
        'se': [_mapCoordinates[i][1].latitude, _mapCoordinates[i][1].longitude]
      };
      //_showDeleteIcon[i] = true;
    }

    String uid = FirebaseAuth.instance.currentUser!.uid;
    CollectionReference farmCollection =
        FirebaseFirestore.instance.collection('farms');
    DocumentReference farmDoc = farmCollection.doc(uid);

    await farmDoc.get().then((doc) => {
          if (doc.exists)
            {
              farmDoc.update({'maps': dataMap})
            }
          else
            {
              // TODO: feedback (kanskje ikke vise denne widgeten dersom farm ikke er lagt til?)
            },
        });
  }

  void _saveChangedMap(int index) {
    String? newName = _mapNameControllers[index].text;
    if (newName.isNotEmpty) {
      if (!_mapNames.contains(newName)) {
        _mapNames[index] = newName;
        _saveMapData();
        setState(() {
          _showDeleteIcon[index] = true;
        });
      } else {
        setState(() {
          _helpText = 'Kartnavnet $newName finnes allerede, skriv unikt navn';
        });
      }
    } else {
      setState(() {
        _helpText = 'Kartet må ha et navn';
      });
    }
  }

  void _saveNewMap() {
    if (_newCoordinates.length == 2) {
      String newMapName = _newMapNameController.text;
      if (newMapName.isNotEmpty) {
        if (!_mapNames.contains(newMapName)) {
          setState(() {
            _mapNames.add(newMapName);
            _mapCoordinates.add(_newCoordinates);
            _mapNameControllers.add(_newMapNameController);
            _showDeleteIcon.add(true);

            showMap = false;
            _newCoordinatesText = coordinatesPlaceholder;
            _newMapNameController = TextEditingController();
          });
          _saveMapData(); // TODO: try catch and await?
        } else {
          setState(() {
            _helpText =
                'Kartnavnet $newMapName finnes allerede, skriv unikt navn';
          });
        }
      } else {
        setState(() {
          _helpText = 'Skriv inn kartnavn';
        });
      }
    }
  }

  BackdropFilter deleteMapDialog(BuildContext context, int index) {
    return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
        child: AlertDialog(
          title: Text('Slette ${_mapNames[index]}?'),
          //content: const Text('Det går ikke å angre sletting.'),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop('dialog');
                  setState(() {
                    _mapNames.removeAt(index);
                    _mapCoordinates.removeAt(index);
                    _mapNameControllers.removeAt(index);
                  });
                  // TODO: slett i db
                  _saveMapData(); // TODO: fungerer det?
                },
                child: const Text('Ja, slett')),
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop('dialog');
                },
                child: const Text('Nei, ikke slett'))
          ],
        ));
  }

  @override
  void dispose() {
    _newMapNameController.dispose();
    for (TextEditingController controller in _mapNameControllers) {
      controller.dispose();
    }
    super.dispose();
  }
}
