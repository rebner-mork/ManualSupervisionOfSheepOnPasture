import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class TripOverviewList extends StatefulWidget {
  const TripOverviewList({Key? key}) : super(key: key);

  @override
  State<TripOverviewList> createState() => _TripOverviewListState();
}

class _TripOverviewListState extends State<TripOverviewList> {
  late final List<Map<String, Object>> _trips;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _readTrips();
    });
  }

  Future<void> _readTrips() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;

    CollectionReference tripsCollection =
        FirebaseFirestore.instance.collection('trips');
    // sorter på startTime? limit?
    QuerySnapshot tripQuerySnapshot =
        await tripsCollection.where('farmId', isEqualTo: uid).get();
    List<QueryDocumentSnapshot> tripDocs = tripQuerySnapshot.docs;

    _trips = [];

    for (QueryDocumentSnapshot doc in tripDocs) {
      _trips.add({
        'mapName': doc['mapName'],
        'personnelId': doc['personnelId'],
        'startTime': doc['startTime'] as Timestamp,
        'documentReference': doc.reference
      });
    }
    setState(() {
      _isLoading = false;
    });
  }

// TODO: endre personnelId til personnelEmail i Firestore?
// TODO: Begrense antall som hentes fra Firestore? Gjøres med limit
// TODO: Dropdown for å filtrere på 'alle', 'kartnavn1', 'kartnavn2'

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Text('loading')
        : ListView.builder(
            itemCount: _trips.length,
            itemBuilder: (BuildContext context, int index) {
              DateTime startTime =
                  (_trips[index]['startTime']! as Timestamp).toDate();
              String startTimeString =
                  '${startTime.day}/${startTime.month}/${startTime.year}'; //startTime.toIso8601String();

              return ListTile(
                title: Text(_trips[index]['mapName']!.toString()),
                subtitle: Text((startTimeString)),
                onTap: () {},
              );
            });
  }
}
