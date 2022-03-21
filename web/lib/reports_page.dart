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
  late final Set<int> years = {}; //LinkedHashSet();
  late int _selectedYear;

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

    for (QueryDocumentSnapshot tripDoc in tripDocs) {
      years.add((tripDoc['startTime'] as Timestamp).toDate().year);
    }

    debugPrint(years.toString());

    setState(() {
      _selectedYear = years.last;
      _isLoading = false;
    });
  }

  // TODO: håndter ingen oppsynsturer
  // TODO: sorter årstall
  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const LoadingData()
        : Column(
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
                  })
            ],
          );
  }
}
