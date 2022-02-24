import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
  bool _showNewEmailRow = false;

  // Index of an invalid email in _emails. -1 if all emails are valid
  int _indexOfInvalidEmail = -1;
  bool _invalidNewEmail = false;

  final List<String> _emails = [];
  List<String> _oldEmails = [];
  final List<bool> _showDeleteIcon = [];

  final List<TextEditingController> _emailControllers = [];
  TextEditingController _newEmailController = TextEditingController();

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
                ? const [
                    Text(
                      'Laster inn oppsynspersonell...',
                      style: TextStyle(fontSize: 18),
                    )
                  ]
                : [
                    DataTable(
                        border: TableBorder.symmetric(),
                        showCheckboxColumn: false,
                        columns: [
                          DataColumn(
                              label: Text(
                            'E-post',
                            style: dataColumnTextStyle,
                          )),
                          const DataColumn(label: Text(''))
                        ],
                        rows: _existingPersonnelRows() + [_newPersonnelRow()]),
                    const SizedBox(height: 10),
                    Text(
                      _helpText,
                      style: const TextStyle(
                        fontSize: 17,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ]));
  }

  List<DataRow> _existingPersonnelRows() {
    return _emails
        .asMap()
        .entries
        .map((MapEntry<int, String> data) => DataRow(cells: [
              DataCell(
                  Container(
                      color: data.key == _indexOfInvalidEmail
                          ? Colors.yellow.shade200
                          : null,
                      child: TextField(
                        controller: _emailControllers[data.key],
                        decoration: InputDecoration(hintText: writeEmail),
                        onChanged: (email) {
                          setState(() {
                            _showDeleteIcon[data.key] =
                                email == _oldEmails[data.key];
                          });
                        },
                        onSubmitted: (_) => _saveExistingPersonnel(data.key),
                      )),
                  showEditIcon: true),
              DataCell(Container(
                  constraints: const BoxConstraints(minWidth: 165),
                  alignment: Alignment.centerLeft,
                  child: _showDeleteIcon[data.key]
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
                              child: Text('Lagre', style: buttonTextStyle),
                              onPressed: () =>
                                  _saveExistingPersonnel(data.key)),
                          const SizedBox(width: 10),
                          ElevatedButton(
                            style: ButtonStyle(
                                fixedSize: MaterialStateProperty.all(
                                    const Size.fromHeight(35)),
                                textStyle:
                                    MaterialStateProperty.all(buttonTextStyle),
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.red)),
                            child: const Text("Avbryt"),
                            onPressed: () {
                              setState(() {
                                _emailControllers[data.key].text =
                                    _oldEmails[data.key];
                                _showDeleteIcon[data.key] = true;
                                _indexOfInvalidEmail = -1;
                                _helpText = '';
                              });
                            },
                          )
                        ])))
            ]))
        .toList();
  }

  void _saveExistingPersonnel(int index) {
    String newEmail = _emailControllers[index].text;

    if (newEmail != _oldEmails[index]) {
      setState(() {
        if (newEmail.isNotEmpty) {
          if (!_emails.contains(newEmail)) {
            if (validateEmail(newEmail) == null) {
              _helpText = '';
              _showDeleteIcon[index] = true;
              _indexOfInvalidEmail = -1;
              _emails[index] = newEmail;
              _oldEmails = List.from(_emails);
              _savePersonnelData();
            } else {
              _helpText = "'$newEmail' har ikke gyldig format";
              _indexOfInvalidEmail = index;
              _invalidNewEmail = false;
            }
          } else {
            _helpText = nonUniqueEmail;
            _indexOfInvalidEmail = index;
            _invalidNewEmail = false;
          }
        } else {
          _helpText = writeEmail;
          _indexOfInvalidEmail = index;
          _invalidNewEmail = false;
        }
      });
    }
  }

  DataRow _newPersonnelRow() {
    return DataRow(
        cells: _showNewEmailRow
            ? [
                DataCell(
                    Container(
                        color: _invalidNewEmail ? Colors.yellow.shade200 : null,
                        child: TextField(
                          controller: _newEmailController,
                          decoration: InputDecoration(hintText: writeEmail),
                          onSubmitted: (_) {
                            _saveNewPersonnel();
                          },
                        )),
                    showEditIcon: true),
                DataCell(Row(children: [
                  ElevatedButton(
                      style: ButtonStyle(
                          fixedSize: MaterialStateProperty.all(
                              const Size.fromHeight(35))),
                      child: Text('Lagre', style: buttonTextStyle),
                      onPressed: _saveNewPersonnel),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    style: ButtonStyle(
                        fixedSize: MaterialStateProperty.all(
                            const Size.fromHeight(35)),
                        textStyle: MaterialStateProperty.all(buttonTextStyle),
                        backgroundColor: MaterialStateProperty.all(Colors.red)),
                    child: const Text("Avbryt"),
                    onPressed: () {
                      setState(() {
                        _showNewEmailRow = false;
                        _newEmailController.clear();
                        _helpText = '';
                        _invalidNewEmail = false;
                      });
                    },
                  )
                ])),
              ]
            : [
                DataCell.empty,
                DataCell(FloatingActionButton(
                  mini: true,
                  child: const Icon(Icons.add, size: 26),
                  onPressed: () {
                    setState(() {
                      _showNewEmailRow = true;
                    });
                  },
                ))
              ]);
  }

  void _saveNewPersonnel() {
    String email = _newEmailController.text;

    setState(() {
      if (email.isEmpty) {
        _helpText = 'E-post kan ikke være tom';
        _invalidNewEmail = true;
        _indexOfInvalidEmail = -1;
      } else if (_emails.contains(email)) {
        _helpText = nonUniqueEmail;
        _invalidNewEmail = true;
        _indexOfInvalidEmail = -1;
      } else if (validateEmail(email) != null) {
        _invalidNewEmail = true;
        _indexOfInvalidEmail = -1;
        _helpText = email == ''
            ? 'E-post kan ikke være tom'
            : "'$email' har ikke gyldig format for e-post";
      } else {
        _helpText = '';
        _showNewEmailRow = false;
        _invalidNewEmail = false;
        _emails.add(email);
        //_oldEmails = List.from(_emails); TODO: remove?
        _emailControllers.add(_newEmailController);
        _newEmailController = TextEditingController(text: '');
        _showDeleteIcon.add(true);

        _savePersonnelData();
      }
    });
  }

  void _validateEmails() {
    if (_emails.toSet().length < _emails.length) {
      _helpText = nonUniqueEmail;
    } else {
      _helpText = '';
      _indexOfInvalidEmail = -1;
    }
    for (String email in _emails) {
      if (validateEmail(email) != null) {
        setState(() {
          _indexOfInvalidEmail = _emails.indexOf(email);
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
          title: Text("Slette '${_emails[index]}'?"),
          content: const Text('Sletting kan ikke angres'),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop('dialog');
                  setState(() {
                    _emails.removeAt(index);
                    _oldEmails.removeAt(index);
                    _emailControllers.removeAt(index);
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

    DocumentSnapshot<Object?> doc = await farmDoc.get();
    if (doc.exists) {
      emails = doc.get('personnel');
      if (emails != null) {
        for (String email in emails) {
          _emails.add(email);
          _showDeleteIcon.add(true);
          _emailControllers.add(TextEditingController(text: email));
        }
        _oldEmails = List.from(emails);
      }
    }
    setState(() {
      _loadingData = false;
    });
  }

  void _savePersonnelData() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;

    // Save in own farm
    CollectionReference farmCollection =
        FirebaseFirestore.instance.collection('farms');
    DocumentReference farmDoc = farmCollection.doc(uid);

    DocumentSnapshot<Object?> doc = await farmDoc.get();
    if (doc.exists) {
      farmDoc.update({'personnel': _emails});
    } else {
      farmDoc.set({
        'maps': null,
        'name': null,
        'address': null,
        'ties': null,
        'eartags': null,
        'personnel': _emails
      });
    }

    // Remove farm from individual personnel if mail was removed
    CollectionReference personnelCollection =
        FirebaseFirestore.instance.collection('personnel');
    DocumentReference personnelDoc;

    for (String oldEmail in _oldEmails) {
      if (!_emails.contains(oldEmail)) {
        personnelDoc = personnelCollection.doc(oldEmail);

        List<dynamic>? farms;

        doc = await personnelDoc.get();
        if (doc.exists) {
          farms = doc.get('farms');
          if (farms!.length == 1) {
            personnelDoc.delete();
          } else {
            personnelDoc.update({
              'farms': FieldValue.arrayRemove([uid]) // TODO: make null if empty
            });
          }
        }
      }
    }

    // Add farm to individual personnel if new mail was added
    for (String email in _emails) {
      if (!_oldEmails.contains(email)) {
        personnelDoc = personnelCollection.doc(email);

        doc = await personnelDoc.get();
        if (doc.exists) {
          personnelDoc.update({
            'farms': FieldValue.arrayUnion([uid])
          });
        } else {
          personnelDoc.set({
            'farms': [uid]
          });
        }
      }
    }
    _oldEmails = List.from(_emails);
  }

  @override
  void dispose() {
    for (TextEditingController controller in _emailControllers) {
      controller.dispose();
    }
    _newEmailController.dispose();
    super.dispose();
  }
}
