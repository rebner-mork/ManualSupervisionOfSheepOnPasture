import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:web/utils/styles.dart';

class DefinePersonnel extends StatefulWidget {
  const DefinePersonnel({Key? key}) : super(key: key);

  @override
  State<DefinePersonnel> createState() => _DefinePersonnelState();
}

class _DefinePersonnelState extends State<DefinePersonnel> {
  _DefinePersonnelState();

  bool _loadingData = false; // TODO: true
  bool _valuesChanged = false;
  bool _equalValues = false;
  bool _personnelAdded = false;
  bool _personnelDeleted = false;

  List<String> _personnel = [];
  List<String> _oldPersonnel = [];

  List<TextEditingController> _personnelControllers = [];

  String _helpText = '';

  @override
  Widget build(BuildContext context) {
    return Material(
        child: Column(
            children: _loadingData
                ? const [Text('Laster data...')]
                : [
                    DataTable(
                        border: TableBorder.symmetric(),
                        showCheckboxColumn: false,
                        columns: [
                          DataColumn(
                              label: Text(
                            'E-post',
                            style: columnNameTextStyle,
                          )),
                          const DataColumn(label: Text(''))
                        ],
                        rows: _existingPersonnelRows() + [_newPersonnelRow()])
                  ]));
  }

  List<DataRow> _existingPersonnelRows() {
    return _personnel
        .asMap()
        .entries
        .map((MapEntry<int, String> data) => DataRow(cells: [
              DataCell(
                  TextField(
                    controller: _personnelControllers[data.key],
                    onChanged: (email) {
                      //_showDeleteIcon[data.key] = false
                    },
                  ),
                  showEditIcon: true),
              DataCell(IconButton(
                icon: Icon(Icons.delete, color: Colors.grey.shade800, size: 26),
                splashRadius: 22,
                hoverColor: Colors.red,
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (_) =>
                          _deletePersonnelDialog(context, data.key));
                },
              ))
            ]))
        .toList();
  }

  DataRow _newPersonnelRow() {
    return DataRow(cells: [
      DataCell.empty,
      DataCell(FloatingActionButton(
        mini: true,
        child: const Icon(Icons.add, size: 26),
        onPressed: () {
          setState(() {
            TextEditingController controller = TextEditingController();
            controller.text = '';
            _personnel.add('');
            _personnelControllers.add(controller);
            _valuesChanged = true;
            _personnelAdded = true;

            _checkEqualEmails();
          });
        },
      ))
    ]);
  }

  void _checkEqualEmails() {
    if (_personnel.toSet().length < _personnel.length) {
      _helpText = 'E-post må være unik';
      _equalValues = true;
    } else {
      _helpText = '';
      _equalValues = false;
    }
  }

  BackdropFilter _deletePersonnelDialog(BuildContext context, int index) {
    return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
        child: AlertDialog(
          title: Text('Slette ${_personnel[index]}?'),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop('dialog');
                  setState(() {
                    _personnel.removeAt(index);
                    _personnelControllers.removeAt(index);

                    _valuesChanged = true;
                    _personnelDeleted = true;

                    _checkEqualEmails();
                  });
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
    for (TextEditingController controller in _personnelControllers) {
      controller.dispose();
    }
    super.dispose();
  }
}
