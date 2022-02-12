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

  List<MapEntry<String, LatLng>> mapDataTwo = [
    MapEntry("Bymarka", LatLng(10, 10)),
    MapEntry("Strindamarka", LatLng(20, 20))
  ]; // TODO: les fra db

  late final Map<String, TextEditingController> _controllers = {};

  bool showMap = false;
  String newButtonText = "Legg til";

  late String helpText;
  String helpTextNorthWest =
      "Klikk og hold på kartet for å markere nordvestlig hjørne av beiteområdet";
  String helpTextSouthEast =
      "Klikk og hold på kartet for å markere sørøstlig hjørne av beiteområdet";
  String helpTextSave =
      "Klikk på lagre-knappen når du har skrevet inn navn på kartområdet";

  @override
  void initState() {
    super.initState();

    helpText = helpTextNorthWest;

    for (MapEntry<String, LatLng> element in mapDataTwo) {
      TextEditingController controller = TextEditingController();
      controller.text = element.key.toString();

      _controllers[element.key] = controller;
    }

    debugPrint(_controllers.toString());

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
                    DataColumn(label: Text("Koordinater")),
                    DataColumn(label: Text('')),
                  ],
                  rows: mapDataTwo
                          .map((MapEntry<String, LatLng> element) => DataRow(
                                  //selected: true,
                                  //onSelectChanged: (bool? selected) {},
                                  cells: [
                                    DataCell(TextField(
                                      controller: _controllers[element.key],
                                      onChanged: (_) {
                                        // Todo: change keys
                                        debugPrint("NÅ");
                                      },
                                    )
                                        //Text(element.key),
                                        /*showEditIcon: true */ /*,placeholder: true*/
                                        ),
                                    DataCell(
                                      Text('(' +
                                          element.value.latitude.toString() +
                                          ', ' +
                                          element.value.longitude.toString() +
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
                        DataRow(cells: [
                          DataCell(showMap
                              ? const TextField(
                                  decoration:
                                      InputDecoration(hintText: 'Skriv navn'))
                              : Container()),
                          DataCell(
                              showMap ? const Text("(?, ?)") : Container()),
                          DataCell(ElevatedButton(
                            child: Text(newButtonText),
                            onPressed: () {
                              setState(() {
                                showMap = true;
                                newButtonText = "Lagre";
                              });
                            },
                          ))
                        ])
                      ]))),
      if (showMap) Text(helpText),
      if (showMap) Flexible(flex: 5, child: DefineMap(onCornerMarked))
    ]));
  }

  void onCornerMarked(int cornerAmount) {
    // TODO: limit map area?
    setState(() {
      helpText = cornerAmount == 1 ? helpTextSouthEast : helpTextSave;
    });
  }
}
