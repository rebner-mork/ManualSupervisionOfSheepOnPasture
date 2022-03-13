import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:web/trips/detailed_trip.dart';
import 'package:web/trips/trip_overview_list.dart';
import 'package:web/utils/custom_widgets.dart';
import 'package:web/utils/styles.dart';
import 'package:latlong2/latlong.dart';

class TripsPage extends StatefulWidget {
  const TripsPage({Key? key}) : super(key: key);

  @override
  State<TripsPage> createState() => _TripsPageState();
}

class _TripsPageState extends State<TripsPage> {
  bool _isLoadingDetailedTrip = false;
  Map<String, Object>? _selectedTripData;

  Future<void> _showDetailedTripData(DocumentReference tripDocReference) async {
    setState(() {
      _isLoadingDetailedTrip = true;
    });

    DocumentSnapshot tripDoc = await tripDocReference.get();

    List<Map<String, double>> track = (tripDoc['track'] as List<dynamic>)
        .map((dynamic trackElement) => (trackElement as Map<String, dynamic>)
            .map((key, value) => MapEntry(key, value as double)))
        .toList();

    QuerySnapshot<Map<String, dynamic>> registrationDocs =
        await tripDocReference.collection('registrations').get();

    List<Map<String, dynamic>> registrations = [];

    for (QueryDocumentSnapshot<Map<String, dynamic>> registrationDoc
        in registrationDocs.docs) {
      registrations.add(registrationDoc.data());
    }

    QuerySnapshot userDocsSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: tripDoc['personnelEmail'])
        .get();
    QueryDocumentSnapshot userDoc = userDocsSnapshot.docs.first;

    DocumentSnapshot farmDoc = await FirebaseFirestore.instance
        .collection('farms')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();

    LatLng northWest = LatLng(
        farmDoc['maps'][tripDoc['mapName']]['northWest']['latitude']! as double,
        farmDoc['maps'][tripDoc['mapName']]['northWest']['longitude']!
            as double);
    LatLng southEast = LatLng(
        farmDoc['maps'][tripDoc['mapName']]['southEast']['latitude']! as double,
        farmDoc['maps'][tripDoc['mapName']]['southEast']['longitude']!
            as double);

    _selectedTripData = {
      'mapName': tripDoc['mapName'],
      'personnelEmail': tripDoc['personnelEmail'],
      'personnelPhone': userDoc['phone'],
      'startTime': tripDoc['startTime'],
      'stopTime': tripDoc['stopTime'],
      'track': track,
      'registrations': registrations,
      'mapCenter': LatLngBounds(LatLng(southEast.latitude, northWest.longitude),
              LatLng(northWest.latitude, southEast.longitude))
          .center
    };

    setState(() {
      _isLoadingDetailedTrip = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      //crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
            width: 128,
            child: TripOverviewList(onTripTapped: _showDetailedTripData)),
        const VerticalDivider(
          width: 0,
          indent: null,
          endIndent: null,
        ),
        Expanded(
            child: Center(
                child: _isLoadingDetailedTrip
                    ? const LoadingData()
                    : _selectedTripData != null
                        ? DetailedTrip(_selectedTripData!)
                        : Text(
                            'Klikk på en oppsynstur i lista til venstre for å se detaljer.',
                            style: feedbackTextStyle))),
      ],
    );
  }
}
