import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome5_icons.dart';

class MyTies extends StatefulWidget {
  const MyTies({Key? key}) : super(key: key);

  @override
  State<MyTies> createState() => _MyTiesState();
}

class _MyTiesState extends State<MyTies> {
  _MyTiesState();

  bool _loadingData = true; // TODO: false

  final Map<Color, int> defaultTieMap = <Color, int>{
    Colors.red: 0,
    Colors.blue: 1,
    Colors.yellow: 2, // TODO: check if no tie
    Colors.green: 3
  };

  final Map<Color, String> colorToString = <Color, String>{
    Colors.red: 'Rød',
    Colors.blue: 'Blå',
    Colors.yellow: 'Gul',
    Colors.green: 'Grønn'
  };

  Map<Color, int> _tieMap = <Color, int>{};

  TextStyle largerTextStyle = TextStyle(fontSize: 16);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      // TODO: les inn fra db
      setState(() {
        _loadingData = false;
      });
    });
  }

// TODO: render loadingText
  @override
  Widget build(BuildContext context) {
    return Material(
        child: _loadingData
            ? const Text('Laster data...')
            : DataTable(
                border: TableBorder.symmetric(),
                columns: const [
                  DataColumn(label: Text('Slipsfarge')),
                  DataColumn(label: Text('Antall lam'))
                ],
                rows: defaultTieMap.entries
                    .map((MapEntry<Color, int> data) => DataRow(cells: [
                          DataCell(Row(children: [
                            Icon(
                              FontAwesome5.black_tie, // Icons.stop
                              color: data.key,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              colorToString[data.key].toString(),
                              style: largerTextStyle,
                            )
                          ])),
                          DataCell(Text(data.value.toString()))
                        ]))
                    .toList(),
              ));
  }
}
