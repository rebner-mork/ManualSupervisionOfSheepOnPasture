import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:web/utils/custom_widgets.dart';
import 'package:web/utils/styles.dart';

class ReportsPage extends StatefulWidget {
  const ReportsPage({Key? key}) : super(key: key);

  @override
  State<ReportsPage> createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage> {
  bool _isLoading = true;
  late final SplayTreeSet<int> years = SplayTreeSet((a, b) => a.compareTo(b));
  late int _selectedYear;
  late bool _tripsExist;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _readTrips();
    });
  }

  void _readTrips() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    CollectionReference tripsCollection =
        FirebaseFirestore.instance.collection('trips');

    QuerySnapshot<Object?> tripsSnapshot =
        await tripsCollection.where('farmId', isEqualTo: uid).get();
    List<QueryDocumentSnapshot<Object?>> tripDocs = tripsSnapshot.docs;

    if (tripDocs.isNotEmpty) {
      for (QueryDocumentSnapshot tripDoc in tripDocs) {
        years.add((tripDoc['startTime'] as Timestamp).toDate().year);
      }

      setState(() {
        _tripsExist = true;
        _selectedYear = years.last;
        _isLoading = false;
      });
    } else {
      setState(() {
        _tripsExist = false;
        _isLoading = false;
      });
    }
  }

  void _generateReport() {}

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const LoadingData()
        : _tripsExist
            ? Column(
                children: [
                  const Text('Her kan du generere og laste ned årsrapporter',
                      style: pageInfoTextStyle),
                  DropdownButton<int>(
                      value: _selectedYear,
                      items: years
                          .map<DropdownMenuItem<int>>(
                              (int year) => DropdownMenuItem(
                                  value: year,
                                  child: Text(
                                    year.toString(),
                                    style: const TextStyle(fontSize: 26),
                                  )))
                          .toList(),
                      onChanged: (int? newYear) {
                        setState(() {
                          _selectedYear = newYear!;
                        });
                      }),
                  ElevatedButton(
                      onPressed: _generateReport,
                      child: const Text(
                        "Generer rapport",
                        style: TextStyle(fontSize: 20),
                      ),
                      style: ElevatedButton.styleFrom(
                        fixedSize: const Size(180, 50),
                      ))
                ],
              )
            : const Center(
                child: Text('Ingen turer har blitt gått',
                    style: feedbackTextStyle));
  }
}
