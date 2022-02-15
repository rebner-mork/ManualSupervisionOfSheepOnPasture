import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome5_icons.dart';

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
    Colors.green: 'Grønn',
    Colors.orange: 'Oransje'
  };

  final Map<Color, String> dialogColorToString = <Color, String>{
    Colors.red: 'rødt',
    Colors.blue: 'blått',
    Colors.yellow: 'gult',
    Colors.green: 'grønt',
    Colors.orange: 'oransje'
  };

  //Map<Color, int> _tieMap = <Color, int>{};
  List<Color> _tieColors = [];
  List<int> _tieLambs = [];
  bool _valuesChanged = false;

  List<Color> _oldTieColors = [];
  List<int> _oldTieLambs = [];

  TextStyle largerTextStyle = const TextStyle(fontSize: 16);
  TextStyle columnNameTextStyle =
      const TextStyle(fontSize: 19, fontWeight: FontWeight.bold);

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      // TODO: les inn fra db istedenfor
      for (MapEntry<Color, int> data in defaultTieMap.entries) {
        _tieColors.add(data.key);
        _tieLambs.add(data.value);
      }

      _oldTieColors = List.from(_tieColors);
      _oldTieLambs = List.from(_tieLambs);

      setState(() {
        _loadingData = false;
      });
    });
  }

  final List<Color> standardColors = [
    Colors.red,
    Colors.blue,
    Colors.yellow,
    Colors.green,
    Colors.orange
  ];

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
                                        items: standardColors
                                            .map((Color color) =>
                                                DropdownMenuItem<DropdownIcon>(
                                                    value: DropdownIcon(color),
                                                    child: DropdownIcon(color)
                                                        .icon))
                                            .toList(),
                                        onChanged: (DropdownIcon? newIcon) {
                                          setState(() {
                                            debugPrint(
                                                _oldTieColors.toString());
                                            _tieColors[data.key] =
                                                newIcon!.icon.color!;
                                            debugPrint(
                                                _oldTieColors.toString());
                                            _valuesChanged = true;
                                          });
                                        }),
                                    const SizedBox(width: 8),
                                    Text(
                                      colorToString[data.value].toString(),
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
                                  setState(() {
                                    _tieLambs[data.key] = newValue!;
                                    _valuesChanged = true;
                                  });
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
                                      builder: (_) => _deleteTieDialog(context,
                                          data.key)); // Avbryt sletting? Nei, si at det ikke kan undoes
                                },
                              ))
                            ]))
                        .toList(),
                  ),
                  if (_valuesChanged)
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      ElevatedButton(
                          style: ButtonStyle(
                              fixedSize: MaterialStateProperty.all(
                                  const Size.fromHeight(35))),
                          child: Text(
                            "Lagre",
                            style: largerTextStyle,
                          ),
                          onPressed: () => {
                                _oldTieColors = _tieColors,
                                _oldTieLambs = _tieLambs,
                                //_saveChangedMap(index), TODO: save to db
                                _valuesChanged = false
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
                          /*_mapNameControllers[index].text =
                                                _mapNames[index],*/
                          setState(() {
                            _valuesChanged = false;
                            // dette er referanseoverføring
                            _tieColors = List.from(_oldTieColors);
                            _tieLambs = List.from(_oldTieLambs);
                            //_showDeleteIcon[index] = true;
                            //_helpText = '';
                          })
                        },
                      ),
                    ])
                ])));
  }

  BackdropFilter _deleteTieDialog(BuildContext context, int index) {
    return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
        child: AlertDialog(
          title:
              Text('Slette ${dialogColorToString[_tieColors[index]]} slips?'),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop('dialog');
                  setState(() {
                    _tieColors.removeAt(index);
                    _tieLambs.removeAt(index);
                  });
                  //_saveTieData(); TODO
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
}
