import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:web/trips/main_trip_info_table.dart';
import 'package:web/trips/map_of_trip_widget.dart';
import 'package:latlong2/latlong.dart';
import 'package:web/trips/eartag_info_table.dart';
import 'package:web/trips/sheep_info_table.dart';
import 'package:web/utils/styles.dart';

class DetailedTrip extends StatefulWidget {
  const DetailedTrip(this.tripData, {Key? key}) : super(key: key);

  final Map<String, Object> tripData;

  @override
  State<DetailedTrip> createState() => _DetailedTripState();
}

class _DetailedTripState extends State<DetailedTrip> {
  late DateTime startTime;
  late DateTime stopTime;
  int sheepAmount = 0;
  int lambAmount = 0;
  int whiteAmount = 0;
  int blackAmount = 0;
  int blackHeadAmount = 0;

  @override
  void initState() {
    super.initState();
    startTime = (widget.tripData['startTime']! as Timestamp).toDate();
    stopTime = (widget.tripData['stopTime']! as Timestamp).toDate();

    for (Map<String, dynamic> registration
        in (widget.tripData['registrations']! as List<Map<String, dynamic>>)) {
      sheepAmount += registration['sheep']! as int;
      lambAmount += registration['lambs']! as int;
      whiteAmount += registration['white']! as int;
      blackAmount += registration['black']! as int;
      blackHeadAmount += registration['blackHead']! as int;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Flexible(
          child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 30),
              child: MainTripInfoTable(
                startTime: startTime,
                stopTime: stopTime,
                email: widget.tripData['personnelEmail']! as String,
                phone: widget.tripData['personnelPhone']! as String,
              ))),
      Row(
        children: [
          Flexible(
              child: Padding(
            padding: tableCellPadding,
            child: SheepInfoTable(
              sheepAmount: sheepAmount,
              lambAmount: lambAmount,
              whiteAmount: whiteAmount,
              blackAmount: blackAmount,
              blackHeadAmount: blackHeadAmount,
            ),
          )),
          Flexible(
              child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 0),
                  child: EartagInfoTable(
                    registrations: widget.tripData['registrations']!
                        as List<Map<String, dynamic>>,
                    definedEartagColors:
                        widget.tripData['definedEartagColors']! as List<String>,
                    definedTieColors:
                        widget.tripData['definedTieColors']! as List<String>,
                  ))),
        ],
      ),
      Flexible(
          child: MapOfTripWidget(
              mapCenter: widget.tripData['mapCenter']! as LatLng,
              track: widget.tripData['track']! as List<Map<String, double>>,
              registrations: widget.tripData['registrations']!
                  as List<Map<String, dynamic>>))
    ]);
  }
}
