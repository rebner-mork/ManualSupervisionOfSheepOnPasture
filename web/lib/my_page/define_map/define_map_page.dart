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

  late String _helpText;
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

    _helpText = helpTextNorthWest;
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
                                      onChanged: (_) {
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
                                          // TODO: sikker? slett lokalt og i db
                                          setState(() {
                                            _mapNames.removeAt(data.key);
                                            _mapCoordinates.removeAt(data.key);
                                            _mapNameControllers
                                                .removeAt(data.key);
                                          });
                                        })
                                    : ElevatedButton(
                                        child: const Text(
                                          "Lagre",
                                          style: TextStyle(fontSize: 18),
                                        ),
                                        onPressed: () {
                                          String? newName =
                                              _mapNameControllers[data.key]
                                                  .text;
                                          if (newName.isNotEmpty) {
                                            // TODO: save to db
                                            setState(() {
                                              _showDeleteIcon[data.key] = true;
                                            });
                                          }
                                        },
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
                                          onPressed: () {
                                            // TODO: sjekk at koordinater er lagt til og at navn er unikt. annet sted: er hjørnene riktig?
                                            debugPrint(_newCoordinates.length
                                                .toString());
                                            if (_newCoordinates.length == 2) {
                                              if (_newMapNameController
                                                  .text.isNotEmpty) {
                                                debugPrint("HER: " +
                                                    _newCoordinates.toString());
                                                setState(() {
                                                  _mapNames.add(
                                                      _newMapNameController
                                                          .text);
                                                  _mapCoordinates
                                                      .add(_newCoordinates);
                                                  _mapNameControllers.add(
                                                      _newMapNameController);
                                                  _showDeleteIcon.add(true);

                                                  showMap = false;
                                                  _newCoordinatesText =
                                                      '(?, ?), (?, ?)';
                                                  _newMapNameController =
                                                      TextEditingController();
                                                });
                                              } else {
                                                setState(() {
                                                  _helpText =
                                                      'Skriv inn kartnavn';
                                                });
                                              }
                                            }
                                          },
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
                                          });
                                        },
                                      ),
                              )
                            ])
                      ]))),
      if (showMap) const SizedBox(height: 10),
      if (showMap)
        (_helpText == helpTextNorthWest || _helpText == helpTextSouthEast)
            ? Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text(
                  _helpText.substring(0, 14),
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  _helpText.substring(14, 38),
                  style: const TextStyle(fontSize: 16),
                ),
                Text(
                  _helpText.substring(38, 57),
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
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
      if (showMap) const SizedBox(height: 10),
      if (showMap)
        Flexible(flex: 5, fit: FlexFit.tight, child: DefineMap(onCornerMarked))
    ]));
  }

  void onCornerMarked(List<LatLng> points) {
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

  @override
  void dispose() {
    _newMapNameController.dispose();
    for (TextEditingController controller in _mapNameControllers) {
      controller.dispose();
    }
    super.dispose();
  }
}
