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

  List<MapEntry<String, List<LatLng>>> mapData = [
    MapEntry("Bymarka", [LatLng(10, 10), LatLng(20, 20)]),
    MapEntry("Strindamarka", [LatLng(20, 20), LatLng(30, 30)])
  ]; // TODO: les fra db

  //late final Map<String, TextEditingController> _controllers = {};

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

  @override
  void initState() {
    super.initState();

    helpText = helpTextNorthWest;

    /*for (MapEntry<String, List<LatLng>> element in mapData) {
      TextEditingController controller = TextEditingController();
      controller.text = element.key.toString();

      _controllers[element.key] = controller;
    }

    debugPrint(_controllers.toString());
    */

    /*_controllers = mapDataTwo
        .map((MapEntry<String, LatLng> element) => MapEntry(
            element.key,
            TextEditingController.fromValue(
                TextEditingValue(text: element.key))))
        .toList();
    debugPrint(_controllers.runtimeType.toString());
    debugPrint(_controllers.toString());*/
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        //color: Colors.blue,
        child: Column(children: [
      Flexible(
          flex: 2,
          fit: FlexFit.tight,
          child: SingleChildScrollView(
              child: DataTable(
                  border: TableBorder.symmetric(),
                  columns: const [
                    DataColumn(label: Text("Kartnavn")),
                    DataColumn(label: Text("Koordinater (NV), (NØ)")),
                    DataColumn(label: Text('')),
                  ],
                  rows: mapData
                          .map((MapEntry<String, List<LatLng>> element) =>
                              DataRow(
                                  //selected: true,
                                  //onSelectChanged: (bool? selected) {},
                                  cells: [
                                    DataCell(Text(element.key)

                                        /*TextField(
                                      controller: _controllers[element.key],
                                      onChanged: (_) {
                                        // Todo: change keys
                                        debugPrint("NÅ");
                                      },
                                    )*/
                                        //Text(element.key),
                                        /*showEditIcon: true */ /*,placeholder: true*/
                                        ),
                                    DataCell(
                                      Text('(' +
                                          element.value[0].latitude.toString() +
                                          ', ' +
                                          element.value[0].longitude
                                              .toString() +
                                          ')' +
                                          ', (' +
                                          element.value[1].latitude.toString() +
                                          ', ' +
                                          element.value[1].longitude
                                              .toString() +
                                          ')'),
                                    ),
                                    DataCell(IconButton(
                                        icon: Icon(
                                          Icons.delete,
                                          color: Colors.grey.shade800,
                                        ),
                                        onPressed:
                                            () {})) // TODO: sikker? slett lokalt og i db
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
                                      child: const Text("Lagre"),
                                      onPressed: () {
                                        // TODO: Sjekk at navn er skrevet inn, sjekk at koordinater er lagt til
                                        if (newNameController.text.isNotEmpty) {
                                          debugPrint("JA");
                                          setState(() {
                                            showMap = false;
                                            mapData.add(MapEntry(
                                                newNameController.text,
                                                newPoints));
                                            newPoints.clear();
                                            newNameController =
                                                TextEditingController();
                                          });
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
      } else {
        // TODO: legg inn koordinatene
        setState(() {
          helpText = helpTextSave;
          newCoordinates =
              '(${points[0].latitude}, ${points[0].longitude}), (${points[1].latitude}, ${points[0].longitude})';
        });
        newPoints = points;
      }
    });
  }
}
