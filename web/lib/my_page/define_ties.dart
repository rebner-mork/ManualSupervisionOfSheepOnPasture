import 'dart:collection';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:web/utils/constants.dart';

class DropdownIcon {
  DropdownIcon(Color iconColor) {
    icon = Icon(FontAwesome5.black_tie, color: iconColor);
  }

  late Icon icon;

  @override
  bool operator ==(Object other) =>
      other is DropdownIcon && other.icon.color == icon.color;

  @override
  int get hashCode => icon.hashCode;
}

class MyTies extends StatefulWidget {
  const MyTies({Key? key}) : super(key: key);

  @override
  State<MyTies> createState() => _MyTiesState();
}

class _MyTiesState extends State<MyTies> {
  _MyTiesState();

  bool _loadingData = true;

  final Map<Color, int> defaultTieMap = <Color, int>{
    Colors.red: 0,
    Colors.blue: 1,
    Colors.yellow: 2,
    Colors.green: 3
  };

  final Map<Color, String> dialogColorToString = <Color, String>{
    Colors.red: 'rødt',
    Colors.blue: 'blått',
    Colors.yellow: 'gult',
    Colors.green: 'grønt',
    Colors.orange: 'oransje'
  };

  List<Color> _tieColors = [];
  List<int> _tieLambs = [];

  List<Color> _oldTieColors = [];
  List<int> _oldTieLambs = [];

  bool _valuesChanged = false;
  bool _equalValues = false;
  String _helpText = '';

  static const String nonUniqueColorFeedback = 'Slipsfarge må være unik';
  static const String nonUniqueLambsFeedback = 'Antall lam må være unikt';

  TextStyle largerTextStyle = const TextStyle(fontSize: 16);
  TextStyle columnNameTextStyle =
      const TextStyle(fontSize: 19, fontWeight: FontWeight.bold);

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _readTieData();
    });
  }

// TODO: legg til slips-knapp
// TODO: sentrer laster data-tekst
  @override
  Widget build(BuildContext context) {
    return Material(
        child: _loadingData
            ? const Text('Laster data...')
            : ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 600),
                child: Column(children: [
                  DataTable(
                    border: TableBorder.symmetric(),
                    columns: [
                      DataColumn(
                          label: Text(
                        'Slipsfarge',
                        style: columnNameTextStyle,
                      )),
                      DataColumn(
                          label: Text(
                        'Antall lam',
                        style: columnNameTextStyle,
                      )),
                      const DataColumn(label: Text('')),
                    ],
                    rows: _tieColors
                        .asMap()
                        .entries
                        .map((MapEntry<int, Color> data) => DataRow(cells: [
                              DataCell(Container(
                                  constraints:
                                      const BoxConstraints(minWidth: 115),
                                  child: Row(children: [
                                    DropdownButton<DropdownIcon>(
                                        value: DropdownIcon(data.value),
                                        items: possibleColors
                                            .map((Color color) =>
                                                DropdownMenuItem<DropdownIcon>(
                                                    value: DropdownIcon(color),
                                                    child: DropdownIcon(color)
                                                        .icon))
                                            .toList(),
                                        onChanged: (DropdownIcon? newIcon) {
                                          _helpText = '';
                                          Color newColor = newIcon!.icon.color!;

                                          if (newColor != data.value) {
                                            setState(() {
                                              _tieColors[data.key] = newColor;
                                              _valuesChanged = true;

                                              if (_tieColors.toSet().length <
                                                  _tieColors.length) {
                                                _helpText =
                                                    'Slipsfarge må være unik';
                                                _equalValues = true;
                                              } else if (_tieLambs
                                                      .toSet()
                                                      .length ==
                                                  _tieLambs.length) {
                                                _helpText = '';
                                                _equalValues = false;
                                              } else {
                                                _helpText =
                                                    nonUniqueLambsFeedback;
                                              }
                                            });
                                          }
                                        }),
                                    const SizedBox(width: 8),
                                    Text(
                                      colorValueToString[data.value.value]
                                          .toString(),
                                      style: largerTextStyle,
                                    ),
                                  ]))),
                              DataCell(Center(
                                  child: DropdownButton<int>(
                                value: _tieLambs[data.key],
                                items: <int>[0, 1, 2, 3, 4, 5, 6]
                                    .map((int value) => DropdownMenuItem<int>(
                                        value: value,
                                        child: Text(
                                          value.toString(),
                                          style: largerTextStyle,
                                        )))
                                    .toList(),
                                onChanged: (int? newValue) {
                                  _helpText = '';
                                  if (newValue! != _tieLambs[data.key]) {
                                    setState(() {
                                      _tieLambs[data.key] = newValue;
                                      _valuesChanged = true;

                                      if (_tieLambs.toSet().length <
                                          _tieLambs.length) {
                                        _helpText = 'Antall lam må være unikt';
                                        _equalValues = true;
                                      } else if (_tieColors.toSet().length ==
                                          _tieColors.length) {
                                        _helpText = '';
                                        _equalValues = false;
                                      } else {
                                        _helpText = nonUniqueColorFeedback;
                                      }
                                    });
                                  }
                                },
                              ))),
                              DataCell(IconButton(
                                icon: Icon(Icons.delete,
                                    color: Colors.grey.shade800, size: 26),
                                splashRadius: 22,
                                hoverColor: Colors.red,
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (_) =>
                                          _deleteTieDialog(context, data.key));
                                },
                              ))
                            ]))
                        .toList(),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    _helpText,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  if (_valuesChanged)
                    Column(children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                                style: ButtonStyle(
                                    fixedSize: MaterialStateProperty.all(
                                        const Size.fromHeight(35)),
                                    backgroundColor: MaterialStateProperty.all(
                                        _equalValues
                                            ? Colors.grey
                                            : Colors.green)),
                                child: Text(
                                  "Lagre",
                                  style: largerTextStyle,
                                  textAlign: TextAlign.center,
                                ),
                                onPressed: () => {
                                      if (!_equalValues)
                                        {
                                          _oldTieColors = _tieColors,
                                          _oldTieLambs = _tieLambs,
                                          setState(() {
                                            _valuesChanged = false;
                                            _helpText = 'Data er lagret';
                                          }),
                                          _saveTieData()
                                        }
                                    }),
                            const SizedBox(width: 10),
                            ElevatedButton(
                              style: ButtonStyle(
                                  fixedSize: MaterialStateProperty.all(
                                      const Size.fromHeight(35)),
                                  backgroundColor:
                                      MaterialStateProperty.all(Colors.red)),
                              child: Text(
                                "Avbryt",
                                style: largerTextStyle,
                              ),
                              onPressed: () => {
                                setState(() {
                                  _valuesChanged = false;
                                  _tieColors = List.from(_oldTieColors);
                                  _tieLambs = List.from(_oldTieLambs);
                                  _helpText = '';
                                })
                              },
                            ),
                          ])
                    ])
                ])));
  }

  BackdropFilter _deleteTieDialog(BuildContext context, int index) {
    return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
        child: AlertDialog(
          title:
              Text('Slette ${dialogColorToString[_tieColors[index]]} slips?'),
          content: const Text('Handlingen kan ikke angres'),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop('dialog');
                  setState(() {
                    _tieColors.removeAt(index);
                    _tieLambs.removeAt(index);
                  });
                  _saveTieData();
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

// TODO: sort on no of lambs
  void _readTieData() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    CollectionReference farmCollection =
        FirebaseFirestore.instance.collection('farms');
    DocumentReference farmDoc = farmCollection.doc(uid);

    LinkedHashMap<String, dynamic> dataMap;

    await farmDoc.get().then((doc) => {
          if (doc.exists)
            {
              dataMap = doc.get('ties'),
              for (MapEntry<String, dynamic> data in dataMap.entries)
                {
                  _tieColors.add(Color(int.parse(data.key, radix: 16))),
                  _tieLambs.add(data.value as int)
                },
              _tieColors.asMap().entries.map((MapEntry<int, Color> data) =>
                  debugPrint(data.key.toString() + data.value.toString()))
            }
          else
            {
              for (MapEntry<Color, int> data in defaultTieMap.entries)
                {_tieColors.add(data.key), _tieLambs.add(data.value)},
            },
          debugPrint(_tieColors.toString()),
          _oldTieColors = List.from(_tieColors),
          _oldTieLambs = List.from(_tieLambs),
          setState(() {
            _loadingData = false;
          })
        });
  }

  void _saveTieData() async {
    Map<String, int> dataMap = <String, int>{};

    for (int i = 0; i < _tieColors.length; i++) {
      dataMap[_tieColors[i].value.toRadixString(16)] = _tieLambs[i];
    }

    String uid = FirebaseAuth.instance.currentUser!.uid;
    CollectionReference farmCollection =
        FirebaseFirestore.instance.collection('farms');
    DocumentReference farmDoc = farmCollection.doc(uid);

    await farmDoc.get().then((doc) => {
          if (doc.exists)
            {
              farmDoc.update({'ties': dataMap})
            }
          else
            {
              farmDoc.set({
                'name': null,
                'address': null,
                'maps': null,
                'ties': dataMap
              })
            }
        });
  }
}
