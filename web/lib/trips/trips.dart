import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:web/trips/trip_overview_list.dart';

class TripsPage extends StatefulWidget {
  const TripsPage({Key? key}) : super(key: key);

  @override
  State<TripsPage> createState() => _TripsPageState();
}

class _TripsPageState extends State<TripsPage> {
  Future<void> _showDetailedTripData(
      DocumentReference tripDocReference) async {}

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          child: TripOverviewList(onTripTapped: _showDetailedTripData),
          width: 128,
        ),
      ],
    );
  }
}
