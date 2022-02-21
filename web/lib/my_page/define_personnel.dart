import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

  bool _loadingData = true;
  bool _equalValues = false;
  bool _invalidValues = false;
  bool _newRow = false;
  bool _invalidNewPersonnel = false;

  final List<bool> _showDeleteIcon = [];

  int _invalidValueIndex = -1;

  final List<String> _personnel = [];
  List<String> _oldPersonnel = [];

  final List<TextEditingController> _personnelControllers = [];
  TextEditingController _newPersonnelController = TextEditingController();

  String _helpText = '';
  final String nonUniqueEmail = 'E-post må være unik';
  final String writeEmail = 'Skriv e-post';

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _readPersonnelData();
    });
  }

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
                        rows: _existingPersonnelRows() + [_newPersonnelRow()]),
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
                          ? Colors.yellow.shade200
                          : null,
                      child: TextField(
                        controller: _personnelControllers[data.key],
                        decoration: InputDecoration(hintText: writeEmail),
                        onChanged: (email) {
                          setState(() {
                            _showDeleteIcon[data.key] =
                                email == _oldPersonnel[data.key];
                          });
                        },
                        onSubmitted: (_) {
                          _saveExistingPersonnel(data.key);
                        },
                      )),
                  showEditIcon: true),
              DataCell(_showDeleteIcon[data.key]
                  ? IconButton(
                      icon: Icon(Icons.delete,
                          color: Colors.grey.shade800, size: 26),
                      splashRadius: 22,
                      hoverColor: Colors.red,
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (_) =>
                                _deletePersonnelDialog(context, data.key));
                      },
                    )
                  : Row(children: [
                      ElevatedButton(
                          style: ButtonStyle(
                              fixedSize: MaterialStateProperty.all(
                                  const Size.fromHeight(35))),
                          child: Text('Lagre', style: largerTextStyle),
                          onPressed: () => _saveExistingPersonnel(data.key)),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        style: ButtonStyle(
                            fixedSize: MaterialStateProperty.all(
                                const Size.fromHeight(35)),
                            textStyle:
                                MaterialStateProperty.all(largerTextStyle),
                            backgroundColor:
                                MaterialStateProperty.all(Colors.red)),
                        child: const Text("Avbryt"),
                        onPressed: () {
                          setState(() {
                            _personnelControllers[data.key].text =
                                _oldPersonnel[data.key];
                            _showDeleteIcon[data.key] = true;
                            _invalidValues = false;
                            _helpText = '';
                          });
                        },
                      )
                    ]))
            ]))
        .toList();
  }

  void _saveExistingPersonnel(int index) {
    String newEmail = _personnelControllers[index].text;

    setState(() {
      if (newEmail.isNotEmpty) {
        if (!_personnel.contains(newEmail)) {
          if (validateEmail(newEmail) == null) {
            _helpText = '';
            _showDeleteIcon[index] = true;
            _invalidValues = false;
            //_invalidValueIndex = -1;
            _personnel[index] = newEmail;
            _oldPersonnel = List.from(_personnel);
            _savePersonnelData();
          } else {
            _helpText = "'$newEmail' har ikke gyldig format";
            _invalidValues = true;
            _invalidValueIndex = index;
            _invalidNewPersonnel = false;
          }
        } else {
          _helpText = nonUniqueEmail;
          _invalidValues = true;
          _invalidValueIndex = index;
          _invalidNewPersonnel = false;
        }
      } else {
        _helpText = writeEmail;
        _invalidValues = true;
        _invalidValueIndex = index;
        _invalidNewPersonnel = false;
      }
    });
  }

  DataRow _newPersonnelRow() {
    return DataRow(
        cells: _newRow
            ? [
                DataCell(
                    Container(
                        color: _invalidNewPersonnel
                            ? Colors.yellow.shade200
                            : null,
                        child: TextField(
                          controller: _newPersonnelController,
                          decoration: InputDecoration(hintText: writeEmail),
                          onSubmitted: (_) {
                            _saveNewPersonnel();
                          },
                        )),
                    showEditIcon: true),
                DataCell(_saveOrCancelNewPersonnel()),
              ]
            : [
                DataCell.empty,
                DataCell(FloatingActionButton(
                  mini: true,
                  child: const Icon(Icons.add, size: 26),
                  onPressed: () {
                    setState(() {
                      _newRow = true;
                    });
                  },
                ))
              ]);
  }

  Row _saveOrCancelNewPersonnel() {
    return Row(children: [
      ElevatedButton(
          style: ButtonStyle(
              fixedSize: MaterialStateProperty.all(const Size.fromHeight(35))),
          child: Text('Lagre', style: largerTextStyle),
          onPressed: () {
            _saveNewPersonnel();
          }),
      const SizedBox(width: 10),
      ElevatedButton(
        style: ButtonStyle(
            fixedSize: MaterialStateProperty.all(const Size.fromHeight(35)),
            textStyle: MaterialStateProperty.all(largerTextStyle),
            backgroundColor: MaterialStateProperty.all(Colors.red)),
        child: const Text("Avbryt"),
        onPressed: () {
          setState(() {
            _newRow = false;
            _newPersonnelController.clear();
            _helpText = '';
            _invalidNewPersonnel = false;
          });
        },
      )
    ]);
  }

  void _saveNewPersonnel() {
    String email = _newPersonnelController.text;

    setState(() {
      // TODO: Markere bakgrunn ved feil?
      if (email.isEmpty) {
        _helpText = 'E-post kan ikke være tom';
        _invalidNewPersonnel = true;
      } else if (_personnel.contains(email)) {
        _helpText = nonUniqueEmail;
        _invalidNewPersonnel = true;
        //_equalValues = true;
      } else if (validateEmail(email) != null) {
        //_invalidValues = true;
        //_invalidValueIndex = _personnel.indexOf(email);
        _invalidNewPersonnel = true;
        _helpText = email == ''
            ? 'E-post kan ikke være tom'
            : "'$email' har ikke gyldig format for e-post";
        //_helpText = '';
        //_equalValues = false;
        //_invalidValues = false;
      } else {
        _helpText = '';
        _newRow = false;
        _invalidNewPersonnel = false;
        _personnel.add(email);
        _oldPersonnel = List.from(_personnel);
        _personnelControllers.add(_newPersonnelController);
        _newPersonnelController = TextEditingController(text: '');
        _showDeleteIcon.add(true);

        _savePersonnelData();
      }
    });
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
                    _oldPersonnel.removeAt(index);
                    _personnelControllers.removeAt(index);
                    _showDeleteIcon.removeAt(index);

                    _validateEmails();
                  });
                  _savePersonnelData();
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

  void _readPersonnelData() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;

    CollectionReference farmCollection =
        FirebaseFirestore.instance.collection('farms');
    DocumentReference farmDoc = farmCollection.doc(uid);

    List<dynamic>? emails;

    await farmDoc.get().then((doc) => {
          if (doc.exists)
            {
              emails = doc.get('personnel'),
              if (emails != null)
                {
                  for (String email in emails!)
                    {
                      _personnel.add(email),
                      _showDeleteIcon.add(true),
                      _personnelControllers
                          .add(TextEditingController(text: email))
                    },
                  _oldPersonnel = List.from(emails!),
                }
            },
          setState(() {
            _loadingData = false;
          })
        });
  }

  void _savePersonnelData() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;

    CollectionReference farmCollection =
        FirebaseFirestore.instance.collection('farms');
    DocumentReference farmDoc = farmCollection.doc(uid);

    await farmDoc.get().then((doc) => {
          if (doc.exists)
            {
              farmDoc.update({'personnel': _personnel})
            }
          else
            {
              farmDoc.set({
                'maps': null,
                'name': null,
                'address': null,
                'ties': null,
                'eartags': null,
                'personnel': _personnel
              })
            },
        });

    CollectionReference personnelCollection =
        FirebaseFirestore.instance.collection('personnel');
    DocumentReference personnelDoc;

    for (String oldEmail in _oldPersonnel) {
      if (!_personnel.contains(oldEmail)) {
        personnelDoc = personnelCollection.doc(oldEmail);

        List<dynamic>? farms;

        await personnelDoc.get().then((doc) => {
              if (doc.exists)
                {
                  farms = doc.get('farms'),
                  if (farms!.length == 1)
                    {personnelDoc.delete()}
                  else
                    {
                      personnelDoc.update({
                        'farms': FieldValue.arrayRemove([uid])
                      }),
                    }
                }
            });
      }
    }

    for (String email in _personnel) {
      if (!_oldPersonnel.contains(email)) {
        personnelDoc = personnelCollection.doc(email);

        await personnelDoc.get().then((doc) => {
              if (doc.exists)
                {
                  personnelDoc.update({
                    'farms': FieldValue.arrayUnion([uid])
                  })
                }
              else
                {
                  personnelDoc.set({
                    'farms': [uid]
                  })
                }
            });
      }
    }
  }

  @override
  void dispose() {
    for (TextEditingController controller in _personnelControllers) {
      controller.dispose();
    }
    super.dispose();
  }
}
