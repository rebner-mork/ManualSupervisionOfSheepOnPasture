import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:web/utils/custom_widgets.dart';

class TripOverviewList extends StatefulWidget {
  const TripOverviewList({this.onTripTapped, Key? key}) : super(key: key);

  final Function(DocumentReference)? onTripTapped;

  @override
  State<TripOverviewList> createState() => _TripOverviewListState();
}

class _TripOverviewListState extends State<TripOverviewList> {
  final List<Map<String, Object>> _trips = [];
  bool _isLoading = true;
  int _selectedTripIndex = -1;

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
    QuerySnapshot tripQuerySnapshot =
        await tripsCollection.where('farmId', isEqualTo: uid).get();

    for (QueryDocumentSnapshot doc in tripQuerySnapshot.docs) {
      _trips.add({
        'mapName': doc['mapName'],
        'startTime': doc['startTime'],
        'docReference': doc.reference
      });
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const LoadingData()
        : _trips.isEmpty
            ? const Text(
                'Det har ikke blitt gått noen oppsynstur enda',
                style: TextStyle(fontSize: 16),
              )
            : ListView.builder(
                // shrinkWrap: true,
                itemCount: _trips.length,
                itemBuilder: (BuildContext context, int index) {
                  DateTime startTime =
                      (_trips[index]['startTime']! as Timestamp).toDate();
                  String startTimeString =
                      '${startTime.day.toString().padLeft(2, '0')}/${startTime.month.toString().padLeft(2, '0')}/${startTime.year}';

                  return ListTile(
                    tileColor:
                        index == _selectedTripIndex ? Colors.green[400] : null,
                    title: Text(startTimeString,
                        style: TextStyle(
                            fontSize: 17,
                            fontWeight: index == _selectedTripIndex
                                ? FontWeight.bold
                                : FontWeight.normal)),
                    subtitle: Text(
                      '${_trips[index]['mapName']!}',
                      style: TextStyle(
                          fontSize: 17,
                          fontWeight: index == _selectedTripIndex
                              ? FontWeight.bold
                              : FontWeight.normal),
                    ),
                    onTap: () {
                      setState(() {
                        _selectedTripIndex = index;
                      });
                      if (widget.onTripTapped != null) {
                        widget.onTripTapped!(_trips[index]['docReference']!
                            as DocumentReference);
                      }
                    },
                  );
                });
  }
}
