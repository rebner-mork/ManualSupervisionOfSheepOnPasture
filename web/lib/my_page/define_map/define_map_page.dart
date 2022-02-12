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

/*  List<String> maps = ["Bymarka", "Område 2"];
  Map mapData = <String, LatLng>{
    "Bymarka": LatLng(10, 10),
    "Strindamarka": LatLng(20, 20)
  };*/

  // TODO: GJØRE OM ALT TIL LISTER OG BRUKE INDEXOF?

  /*List<MapEntry<String, List<LatLng>>> mapData = [
    MapEntry("Bymarka", [LatLng(10, 10), LatLng(20, 20)]),
    MapEntry("Strindamarka", [LatLng(20, 20), LatLng(30, 30)])
  ]; // TODO: les fra db*/

  //final Map<String, TextEditingController> _controllers = {};

  //final Map<String, bool> _showDeleteIcon = {};

  final List<String> _mapNames = ["Bymarka", "Strindamarka"];

  final List<List<LatLng>> _mapCoordinates = [
    [LatLng(10, 10), LatLng(20, 20)],
    [LatLng(20, 20), LatLng(30, 30)]
  ];

  final List<TextEditingController> _mapNameControllers = [];

  final List<bool> _showDeleteIcon = [];

  bool showMap = false;
  String newButtonText = "Legg til";

  late String helpText;
  String helpTextNorthWest =
      "Klikk og hold på kartet for å markere nordvestlig hjørne av beiteområdet";
  String helpTextSouthEast =
      "Klikk og hold på kartet for å markere sørøstlig hjørne av beiteområdet";
  String helpTextSave =
      "Klikk på lagre-knappen når du har skrevet inn navn på kartområdet";

  String newCoordinates = "(?, ?), (?, ?)";

  List<LatLng> newPoints = [];

  TextEditingController newNameController = TextEditingController();

  String selectedRowKey = '';

  @override
  void initState() {
    super.initState();

    helpText = helpTextNorthWest;

    _mapNames.forEach((String mapName) {
      TextEditingController controller = TextEditingController();
      controller.text = mapName;
      _mapNameControllers.add(controller);

      _showDeleteIcon.add(true);
    });

    /*
    for (MapEntry<String, List<LatLng>> element in mapData) {
      TextEditingController controller = TextEditingController();
      controller.text = element.key.toString();
      _controllers[element.key] = controller;

      _showDeleteIcon[element.key] = true;
    }
    debugPrint(_controllers.toString());*/
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        child: Column(children: [
      Flexible(
          flex: 2,
          fit: FlexFit.tight,
          child: SingleChildScrollView(
              child: DataTable(
                  // TODO: increase text size, add image of map?
                  border: TableBorder.symmetric(),
                  showCheckboxColumn: false,
                  columns: const [
                    DataColumn(label: Text("Kartnavn")),
                    DataColumn(label: Text("Koordinater (NV), (NØ)")),
                    DataColumn(label: Text('')),
                  ],
                  rows: _mapNames
                          .asMap()
                          .entries
                          .map((MapEntry<int, String> data) => DataRow(cells: [
                                DataCell(
                                    //Text(data.key)

                                    TextField(
                                      controller: _mapNameControllers[
                                          data.key], //_controllers[data.key],
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
                                      //data.value[0].latitude.toString() +
                                      ', ' +
                                      _mapCoordinates[data.key][0]
                                          .longitude
                                          .toString() +
                                      //data.value[0].longitude.toString() +
                                      ')' +
                                      ', (' +
                                      _mapCoordinates[data.key][1]
                                          .latitude
                                          .toString() +
                                      //data.value[1].latitude.toString() +
                                      ', ' +
                                      _mapCoordinates[data.key][1]
                                          .longitude
                                          .toString() +
                                      //data.value[1].longitude.toString() +
                                      ')'),
                                ),
                                DataCell(_showDeleteIcon[data.key]
                                    ? IconButton(
                                        icon: Icon(
                                          Icons.delete,
                                          color: Colors.grey.shade800,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            _mapNames.removeAt(data.key);
                                            _mapCoordinates.removeAt(data.key);
                                            _mapNameControllers
                                                .removeAt(data.key);
                                            //mapData.remove(data);
                                          });
                                        })
                                    : ElevatedButton(
                                        child: const Text("Lagre"),
                                        onPressed: () {
                                          String? newName =
                                              _mapNameControllers[data.key]
                                                  .text;
                                          //_controllers[data.key]?.text;
                                          if (newName.isNotEmpty) {
                                            // TODO: save to db
                                            /*int index = mapData.indexOf(data);
                                            mapData[index] =
                                                MapEntry(newName, data.value);*/

                                            //_controllers
                                            setState(() {
                                              _showDeleteIcon[data.key] = true;
                                            });
                                            // Husk alle
                                          }
                                        }, // TODO
                                      )) // TODO: sikker? slett lokalt og i db
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
                                      controller: newNameController,
                                      decoration: const InputDecoration(
                                          hintText: 'Skriv navn'))
                                  : Container()),
                              DataCell(
                                  showMap ? Text(newCoordinates) : Container()),
                              DataCell(showMap
                                  ? ElevatedButton(
                                      child: const Text('Lagre'),
                                      onPressed: () {
                                        // TODO: sjekk at koordinater er lagt til og at navn er unikt. annet sted: er hjørnene riktig?
                                        debugPrint(newPoints.length.toString());
                                        if (newPoints.length == 2) {
                                          if (newNameController
                                              .text.isNotEmpty) {
                                            debugPrint(
                                                "HER: " + newPoints.toString());
                                            setState(() {
                                              _mapNames
                                                  .add(newNameController.text);
                                              _mapCoordinates.add(newPoints);
                                              _mapNameControllers
                                                  .add(newNameController);
                                              _showDeleteIcon.add(true);

                                              /*mapData.add(MapEntry(
                                                newNameController.text,
                                                newPoints));*/
                                              showMap = false;
                                              newCoordinates = '(?, ?), (?, ?)';
                                              newNameController =
                                                  TextEditingController();
                                            });
                                          } else {
                                            setState(() {
                                              helpText = 'Skriv inn kartnavn';
                                            });
                                          }
                                        }
                                      },
                                    )
                                  : ElevatedButton(
                                      child: const Text("Legg til"),
                                      onPressed: () {
                                        setState(() {
                                          showMap = true;
                                        });
                                      },
                                    ))
                            ])
                      ]))),
      if (showMap) Text(helpText),
      if (showMap) Flexible(flex: 5, child: DefineMap(onCornerMarked))
    ]));
  }

  void onCornerMarked(List<LatLng> points) {
    // TODO: limit map area?
    setState(() {
      helpText = points.length == 1 ? helpTextSouthEast : helpTextSave;

      if (points.length == 1) {
        helpText = helpTextSouthEast;
        setState(() {
          newCoordinates = '(${points[0].latitude}, ${points[0].longitude})';
        });
      } else {
        // TODO: legg inn koordinatene
        setState(() {
          helpText = helpTextSave;
          newCoordinates =
              '(${points[0].latitude}, ${points[0].longitude}), (${points[1].latitude}, ${points[0].longitude})';
          newPoints = points;
        });
      }
    });
  }

  @override
  void dispose() {
    newNameController.dispose();
    super.dispose();
  }
}
