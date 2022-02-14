import 'dart:collection';
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

  final List<String> _mapNames = [];
  final List<List<LatLng>> _mapCoordinates = [];
  final List<TextEditingController> _mapNameControllers = [];
  final List<bool> _showDeleteIcon = [];

  TextEditingController _newMapNameController = TextEditingController();
  List<LatLng> _newCoordinates = [];
  late String _newCoordinatesText;
  static const String coordinatesPlaceholder = "(?, ?), (?, ?)";

  bool showMap = false;
  bool _loadingData = true;

  String _helpText = '';
  static const String helpTextNorthWest =
      "Klikk og hold på kartet for å markere nordvestlig hjørne av beiteområdet";
  static const String helpTextSouthEast =
      "Klikk og hold på kartet for å markere sørøstlig hjørne av beiteområdet";
  static const String helpTextSave =
      "Klikk på lagre-knappen når du har skrevet inn navn på kartområdet";
  static const String secondMarkerIncorrectlyPlaced =
      "Sørøstlig hjørne må være sørøst for nordvest-markøren. Klikk og hold på kartet på nytt for å markere sørøstlig hjørne av beiteområdet";

  final TextStyle largerTextStyle = const TextStyle(fontSize: 18);
  final TextStyle columnNameStyle =
      const TextStyle(fontSize: 18, fontWeight: FontWeight.bold);

  @override
  void initState() {
    super.initState();

    _newCoordinatesText = coordinatesPlaceholder;

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _readMapData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        child: Column(children: [
      Flexible(
          flex: 2,
          child: _loadingData
              ? Text(
                  'Laster data...',
                  style: largerTextStyle,
                )
              : SingleChildScrollView(
                  child: DataTable(
                      border: TableBorder.symmetric(),
                      showCheckboxColumn: false,
                      columns: _tableColumns(),
                      rows: _existingMapRows() + [_newMapRow()]))),
      const SizedBox(height: 10),
      _helpTextWidgets(),
      const SizedBox(height: 10),
      if (showMap)
        Flexible(
            flex: 5,
            fit: FlexFit.tight,
            child: DefineMap(_onCornerMarked, _secondMarkerIncorrectlyPlaced))
    ]));
  }

  void _onCornerMarked(List<LatLng> points) {
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

  void _secondMarkerIncorrectlyPlaced() {
    setState(() {
      _helpText = secondMarkerIncorrectlyPlaced;
    });
  }

  void _readMapData() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;

    CollectionReference farmCollection =
        FirebaseFirestore.instance.collection('farms');
    DocumentReference farmDoc = farmCollection.doc(uid);

    Map<String, Map<String, List<double>>> dataMap;
    LinkedHashMap<String, dynamic>? linkedHashMap;
    TextEditingController textController;
    List<List<double>> coordinates;

    await farmDoc.get().then((doc) => {
          if (doc.exists)
            {
              linkedHashMap = doc.get('maps'),
              if (linkedHashMap != null)
                {
                  dataMap = _castFromDynamic(linkedHashMap),
                  for (MapEntry<String, Map<String, List<double>>> data
                      in dataMap.entries)
                    {
                      _mapNames.add(data.key),
                      textController = TextEditingController(),
                      textController.text = data.key,
                      _mapNameControllers.add(textController),
                      coordinates = data.value.values.toList(),
                      _mapCoordinates.add([
                        LatLng(coordinates[0][0], coordinates[0][1]),
                        LatLng(coordinates[1][0], coordinates[1][1])
                      ]),
                      _showDeleteIcon.add(true),
                    },
                }
            },
          setState(() {
            _loadingData = false;
          })
        });
  }

  void _saveMapData() async {
    Map dataMap = <String, Map<String, List<double>>>{};
    for (int i = 0; i < _mapNames.length; i++) {
      dataMap[_mapNames[i]] = <String, List<double>>{
        'nw': [_mapCoordinates[i][0].latitude, _mapCoordinates[i][0].longitude],
        'se': [_mapCoordinates[i][1].latitude, _mapCoordinates[i][1].longitude]
      };
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
              farmDoc.set({'maps': dataMap, 'name': null, 'address': null})
            },
        });
  }

  _castFromDynamic(LinkedHashMap<String, dynamic>? linkedHashMap) {
    return linkedHashMap!
        .map((key, value) => MapEntry(key, value as Map<String, dynamic>))
        .map((key, value) => MapEntry(key,
            value.map((key, value) => MapEntry(key, value as List<dynamic>))))
        .map((key, value) => MapEntry(
            key,
            value.map((key, value) =>
                MapEntry(key, value.map((e) => e as double).toList()))));
  }

  void _saveChangedMap(int index) {
    String? newName = _mapNameControllers[index].text;
    if (newName.isNotEmpty) {
      if (!_mapNames.contains(newName)) {
        _mapNames[index] = newName;
        _saveMapData();
        setState(() {
          _showDeleteIcon[index] = true;
          _helpText = '';
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

            _helpText = '';
          });
          _saveMapData();
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
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop('dialog');
                  setState(() {
                    _mapNames.removeAt(index);
                    _mapCoordinates.removeAt(index);
                    _mapNameControllers.removeAt(index);
                  });
                  _saveMapData();
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

  List<DataColumn> _tableColumns() {
    return [
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
    ];
  }

  List<DataRow> _existingMapRows() {
    return _mapNames
        .asMap()
        .entries
        .map((MapEntry<int, String> data) => DataRow(cells: [
              DataCell(
                  TextField(
                    controller: _mapNameControllers[data.key],
                    onChanged: (name) {
                      setState(() {
                        _showDeleteIcon[data.key] = false;
                      });
                    },
                  ),
                  showEditIcon: true),
              DataCell(_coordinatesCell(data.key)),
              DataCell(_deleteOrRenameMapCell(data.key))
            ]))
        .toList();
  }

  DataRow _newMapRow() {
    return DataRow(
        color:
            showMap ? MaterialStateProperty.all(Colors.yellow.shade200) : null,
        cells: [
          DataCell(
              showMap
                  ? TextField(
                      controller: _newMapNameController,
                      decoration: const InputDecoration(hintText: 'Skriv navn'))
                  : Container(),
              showEditIcon: showMap ? true : false),
          DataCell(showMap ? Text(_newCoordinatesText) : Container()),
          DataCell(_newMapCell())
        ]);
  }

  _newMapCell() {
    return showMap
        ? Row(children: [
            ElevatedButton(
              style: ButtonStyle(
                  fixedSize:
                      MaterialStateProperty.all(const Size.fromHeight(35))),
              child: Text('Lagre', style: largerTextStyle),
              onPressed: () => _saveNewMap(),
            ),
            const SizedBox(width: 10),
            ElevatedButton(
              style: ButtonStyle(
                  fixedSize:
                      MaterialStateProperty.all(const Size.fromHeight(35)),
                  textStyle: MaterialStateProperty.all(largerTextStyle),
                  backgroundColor: MaterialStateProperty.all(Colors.red)),
              child: const Text("Avbryt"),
              onPressed: () {
                setState(() {
                  showMap = false;
                  _newCoordinatesText = coordinatesPlaceholder;
                  _newMapNameController.clear();
                  _helpText = '';
                });
              },
            )
          ])
        : ElevatedButton(
            style: ButtonStyle(
                fixedSize:
                    MaterialStateProperty.all(const Size.fromHeight(35))),
            child: Text("Legg til", style: largerTextStyle),
            onPressed: () {
              setState(() {
                showMap = true;
                _helpText = helpTextNorthWest;
              });
            },
          );
  }

  Text _coordinatesCell(int index) {
    return Text('(' +
        _mapCoordinates[index][0].latitude.toString() +
        ', ' +
        _mapCoordinates[index][0].longitude.toString() +
        ')' +
        ', (' +
        _mapCoordinates[index][1].latitude.toString() +
        ', ' +
        _mapCoordinates[index][1].longitude.toString() +
        ')');
  }

  _deleteOrRenameMapCell(int index) {
    return _showDeleteIcon[index]
        ? IconButton(
            icon: Icon(
              Icons.delete,
              color: Colors.grey.shade800,
              size: 26,
            ),
            splashRadius: 22,
            hoverColor: Colors.red,
            onPressed: () => showDialog(
                context: context,
                builder: (_) => deleteMapDialog(context, index)))
        : Row(children: [
            ElevatedButton(
              style: ButtonStyle(
                  fixedSize:
                      MaterialStateProperty.all(const Size.fromHeight(35))),
              child: Text(
                "Lagre",
                style: largerTextStyle,
              ),
              onPressed: () => _saveChangedMap(index),
            ),
            const SizedBox(width: 10),
            ElevatedButton(
              style: ButtonStyle(
                  fixedSize:
                      MaterialStateProperty.all(const Size.fromHeight(35)),
                  backgroundColor: MaterialStateProperty.all(Colors.red)),
              child: Text(
                "Avbryt",
                style: largerTextStyle,
              ),
              onPressed: () => {
                _mapNameControllers[index].text = _mapNames[index],
                setState(() {
                  _showDeleteIcon[index] = true;
                  _helpText = '';
                })
              },
            ),
          ]);
  }

  _helpTextWidgets() {
    return (_helpText == helpTextNorthWest || _helpText == helpTextSouthEast)
        ? Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(
              _helpText.substring(0, 14),
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              _helpText.substring(14, 38),
              style: const TextStyle(fontSize: 16),
            ),
            Text(
              _helpText.substring(38, 57),
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              _helpText.substring(57),
              style: const TextStyle(fontSize: 16),
            ),
          ])
        : Text(
            _helpText,
            style: const TextStyle(fontSize: 16),
          );
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
