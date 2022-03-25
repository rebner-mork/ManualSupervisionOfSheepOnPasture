import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:web/utils/custom_widgets.dart';
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
  bool _showNewPersonnelRow = false;

  final List<String> _personnelEmails = [];
  final List<String> _personnelNames = [];
  final List<String> _personnelPhones = [];
  List<String> _oldEmails = [];
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
                ? const [SizedBox(height: 20), LoadingData()]
                : [
                    Column(children: [
                      const SizedBox(height: 20),
                      const Text('Mitt oppsynspersonell',
                          style: pageHeadlineTextStyle),
                      const SizedBox(height: 10),
                      const Text(
                          'Her kan du legge til brukere som kan gå oppsynstur for deg i appen.',
                          style: pageInfoTextStyle),
                      DataTable(
                          border: TableBorder.symmetric(),
                          showCheckboxColumn: false,
                          columns: const [
                            DataColumn(
                                label: Text(
                              'Navn',
                              style: dataColumnTextStyle,
                            )),
                            DataColumn(
                                label: Text(
                              'Telefon',
                              style: dataColumnTextStyle,
                            )),
                            DataColumn(
                                label: Text(
                              'E-post',
                              style: dataColumnTextStyle,
                            )),
                            DataColumn(label: Text(''))
                          ],
                          rows: _existingPersonnelRows() + [_newPersonnelRow()])
                    ]),
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
    return _personnelEmails
        .asMap()
        .entries
        .map((MapEntry<int, String> data) => DataRow(cells: [
              DataCell(Text(
                _personnelNames[data.key],
                style: const TextStyle(fontSize: 16),
              )),
              DataCell(Text(
                _personnelPhones[data.key],
                style: const TextStyle(fontSize: 16),
              )),
              DataCell(Text(
                _personnelEmails[data.key],
                style: const TextStyle(fontSize: 16),
              )),
              DataCell(Container(
                  constraints: const BoxConstraints(minWidth: 165),
                  alignment: Alignment.centerLeft,
                  child: IconButton(
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
                  ))),
            ]))
        .toList();
  }

  DataRow _newPersonnelRow() {
    return DataRow(
        cells: _showNewPersonnelRow
            ? [
                DataCell.empty,
                DataCell.empty,
                DataCell(
                    TextField(
                      controller: _newEmailController,
                      decoration: InputDecoration(hintText: writeEmail),
                      onSubmitted: (_) {
                        _saveNewPersonnel();
                      },
                    ),
                    showEditIcon: true),
                DataCell(Row(children: [
                  ElevatedButton(
                      style: ButtonStyle(
                          fixedSize: MaterialStateProperty.all(
                              const Size.fromHeight(35))),
                      child: const Text('Lagre', style: buttonTextStyle),
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
                        _showNewPersonnelRow = false;
                        _newEmailController.clear();
                        _helpText = '';
                      });
                    },
                  )
                ])),
              ]
            : [
                DataCell.empty,
                DataCell.empty,
                DataCell.empty,
                DataCell(FloatingActionButton(
                  mini: true,
                  child: const Icon(Icons.add, size: 26),
                  onPressed: () {
                    setState(() {
                      _showNewPersonnelRow = true;
                    });
                  },
                ))
              ]);
  }

  Future<void> _saveNewPersonnel() async {
    String email = _newEmailController.text;

    bool userExists = false;
    QuerySnapshot userQuerySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: email)
        .get();
    if (userQuerySnapshot.size != 0) {
      userExists = true;
    }

    setState(() {
      if (email.isEmpty) {
        _helpText = 'E-post kan ikke være tom';
      } else if (_personnelEmails.contains(email)) {
        _helpText = nonUniqueEmail;
      } else if (validateEmail(email) != null) {
        _helpText = email == ''
            ? 'E-post kan ikke være tom'
            : "'$email' har ikke gyldig format for e-post";
      } else {
        if (userExists) {
          _helpText = '';
          _showNewPersonnelRow = false;
          _personnelEmails.add(email);
          // ADD i de nye tabellene
          _newEmailController = TextEditingController(text: '');

          _savePersonnelData();
        } else {
          _helpText = 'Det finnes ingen bruker med e-posten \'$email\'';
        }
      }
    });
  }

  void _validateEmails() {
    if (_personnelEmails.toSet().length < _personnelEmails.length) {
      _helpText = nonUniqueEmail;
    } else {
      _helpText = '';
    }
    for (String email in _personnelEmails) {
      if (validateEmail(email) != null) {
        setState(() {
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
          title: Text("Slette '${_personnelEmails[index]}'?"),
          content: const Text('Sletting kan ikke angres'),
          actions: [
            TextButton(
                onPressed: () async {
                  Navigator.of(context).pop('dialog');
                  setState(() {
                    _personnelEmails.removeAt(index);
                  });
                  await _savePersonnelData();
                  setState(() {
                    _oldEmails.removeAt(index);

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
        QuerySnapshot personnelSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .where('email', whereIn: emails)
            .get();
        for (QueryDocumentSnapshot personnelDoc in personnelSnapshot.docs) {
          _personnelEmails.add(personnelDoc['email']);
          _personnelNames.add(personnelDoc['name']);
          _personnelPhones.add(personnelDoc['phone']);
        }
        _oldEmails = List.from(emails);
      }
    }
    setState(() {
      _loadingData = false;
    });
  }

  Future<void> _savePersonnelData() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;

    // Save in own farm
    CollectionReference farmCollection =
        FirebaseFirestore.instance.collection('farms');
    DocumentReference farmDoc = farmCollection.doc(uid);

    DocumentSnapshot<Object?> doc = await farmDoc.get();
    if (doc.exists) {
      farmDoc.update({'personnel': _personnelEmails});
    } else {
      farmDoc.set({
        'maps': null,
        'name': null,
        'address': null,
        'ties': null,
        'eartags': null,
        'personnel': _personnelEmails
      });
    }

    // Remove farm from individual personnel if mail was removed
    CollectionReference personnelCollection =
        FirebaseFirestore.instance.collection('personnel');
    DocumentReference personnelDoc;

    for (String oldEmail in _oldEmails) {
      if (!_personnelEmails.contains(oldEmail)) {
        personnelDoc = personnelCollection.doc(oldEmail);

        List<dynamic>? farms;

        doc = await personnelDoc.get();
        if (doc.exists) {
          farms = doc.get('farms');
          if (farms!.length == 1) {
            personnelDoc.delete();
          } else {
            personnelDoc.update({
              'farms': FieldValue.arrayRemove([uid])
            });
          }
        }
      }
    }

    // Add farm to individual personnel if new mail was added
    for (String email in _personnelEmails) {
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
    _oldEmails = List.from(_personnelEmails);
  }

  @override
  void dispose() {
    _newEmailController.dispose();
    super.dispose();
  }
}
