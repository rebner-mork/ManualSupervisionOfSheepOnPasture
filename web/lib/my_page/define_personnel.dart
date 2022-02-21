import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:web/utils/constants.dart';
import 'package:web/utils/styles.dart';
import 'package:web/utils/validation.dart';

class DefinePersonnel extends StatefulWidget {
  const DefinePersonnel({Key? key}) : super(key: key);

  @override
  State<DefinePersonnel> createState() => _DefinePersonnelState();
}

class _DefinePersonnelState extends State<DefinePersonnel> {
  _DefinePersonnelState();

  bool _loadingData = false; // TODO: true
  bool _equalValues = false;
  bool _invalidValues = false;
  bool _personnelDeleted = false;

  int _invalidValueIndex = -1;

  List<String> _personnel = [];
  List<String> _oldPersonnel = [];

  List<TextEditingController> _personnelControllers = [];
  List<TextEditingController> _oldPersonnelControllers = [];

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
                        rows: _existingPersonnelRows() + [_addPersonnelRow()]),
                    const SizedBox(height: 10),
                    Text(
                      _helpText,
                      style: TextStyle(
                          fontSize: 17,
                          color: _helpText == dataSavedFeedback
                              ? Colors.green
                              : null),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    _saveOrDeleteButtons(),
                  ]));
  }

  List<DataRow> _existingPersonnelRows() {
    return _personnel
        .asMap()
        .entries
        .map((MapEntry<int, String> data) => DataRow(cells: [
              DataCell(
                  Container(
                      color: _invalidValues && data.key == _invalidValueIndex
                          ? Colors.yellow.shade200 // TODO: check shade
                          : null,
                      child: TextField(
                        controller: _personnelControllers[data.key],
                        decoration:
                            const InputDecoration(hintText: 'Skriv e-post'),
                        onChanged: (email) {
                          setState(() {
                            _personnel[data.key] = email;
                          });
                          //_showDeleteIcon[data.key] = false
                        },
                      )),
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

  DataRow _addPersonnelRow() {
    return DataRow(cells: [
      DataCell.empty,
      DataCell(FloatingActionButton(
        mini: true,
        child: const Icon(Icons.add, size: 26),
        onPressed: () {
          setState(() {
            //_addPersonnel = true;
            //_invalidValues = true;
            //_invalidValueIndex = _personnel.length;
            _personnel.add('');
            TextEditingController controller = TextEditingController();
            controller.text = '';
            _personnelControllers.add(controller);
          });
        },
      ))
    ]);
  }

  Column _saveOrDeleteButtons() {
    return Column(children: [
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        ElevatedButton(
            style: ButtonStyle(
                fixedSize: MaterialStateProperty.all(const Size.fromHeight(35)),
                backgroundColor: MaterialStateProperty.all(
                    _equalValues ? Colors.grey : Colors.green)),
            child: Text(
              "Lagre",
              style: largerTextStyle,
              textAlign: TextAlign.center,
            ),
            onPressed: () => {
                  // TODO: validate
                  _validateEmails(),
                  if (!_equalValues && !_invalidValues && _personnel.isNotEmpty)
                    {
                      _oldPersonnel = List.from(_personnel),
                      _oldPersonnelControllers =
                          List.from(_personnelControllers),
                      // TODO: controllergreier?
                      setState(() {
                        _helpText = dataSavedFeedback;
                        _personnelDeleted = false;
                      }),
                      //_savePersonnelData() TODO
                    }
                }),
        const SizedBox(width: 10),
        ElevatedButton(
          style: ButtonStyle(
              fixedSize: MaterialStateProperty.all(const Size.fromHeight(35)),
              backgroundColor: MaterialStateProperty.all(Colors.red)),
          child: Text(
            "Avbryt",
            style: largerTextStyle,
          ),
          onPressed: () => {
            setState(() {
              _personnelDeleted = false;
              _invalidValues = false; // TODO: blir dette riktig?
              _personnel = List.from(_oldPersonnel);
              _personnelControllers = _oldPersonnelControllers;
              // controlergreier? TODO
              _helpText = '';
            })
          },
        ),
      ])
    ]);
  }

  void _validateEmails() {
    if (_personnel.toSet().length < _personnel.length) {
      _helpText = 'E-post må være unik';
      _equalValues = true;
    } else {
      _helpText = '';
      _equalValues = false;
      _invalidValues = false;
    }
    for (String email in _personnel) {
      if (validateEmail(email) != null) {
        setState(() {
          _invalidValues = true;
          _invalidValueIndex = _personnel.indexOf(email);
          _helpText = email == ''
              ? 'E-post kan ikke være tom'
              : "'$email' har ikke gyldig format";
        });
        break;
      }
    }
  }

  BackdropFilter _deletePersonnelDialog(BuildContext context, int index) {
    return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
        child: AlertDialog(
          title: Text("Slette '${_personnel[index]}'?"),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop('dialog');
                  setState(() {
                    _personnel.removeAt(index);
                    _personnelControllers.removeAt(index);
                    _personnelDeleted = true;

                    _validateEmails();
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
