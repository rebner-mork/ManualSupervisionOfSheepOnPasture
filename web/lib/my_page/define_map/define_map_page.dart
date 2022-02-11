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

  List<String> maps = ["Bymarka", "Område 2"];

  List<MapEntry<String, LatLng>> mapDataTwo = [
    MapEntry("Bymarka", LatLng(10, 10)),
    MapEntry("Strindamarka", LatLng(20, 20))
  ];

  Map mapData = <String, LatLng>{
    "Bymarka": LatLng(10, 10),
    "Strindamarka": LatLng(20, 20)
  };

  @override
  Widget build(BuildContext context) {
    return Material(
        color: Colors.blue,
        child: Column(children: [
          Flexible(
              flex: 1,
              child: SingleChildScrollView(
                  child: DataTable(
                      //border: TableBorder.all(),
                      columns: const [
                    DataColumn(label: Text("Kartnavn")),
                    DataColumn(label: Text("Koordinater"))
                  ],
                      rows: mapDataTwo
                          .map((MapEntry<String, LatLng> element) =>
                              DataRow(cells: [
                                DataCell(Text(element.key)),
                                DataCell(Text('(' +
                                    element.value.latitude.toString() +
                                    ', ' +
                                    element.value.longitude.toString() +
                                    ')'))
                              ]))
                          .toList()))),
          const Flexible(flex: 1, child: DefineMap())
        ]));
  }
}
