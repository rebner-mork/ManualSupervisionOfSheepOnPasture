import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:web/trips/main_trip_info_table.dart';
import 'package:web/trips/map_of_trip_widget.dart';
import 'package:latlong2/latlong.dart';
import 'package:web/trips/eartag_info_table.dart';
import 'package:web/trips/sheep_info_table.dart';
import 'package:web/utils/constants.dart';
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
  Map<String, int> sheepData = {};
  Map<String, int> eartagData = {};

  @override
  void initState() {
    super.initState();
    startTime = (widget.tripData['startTime']! as Timestamp).toDate();
    stopTime = (widget.tripData['stopTime']! as Timestamp).toDate();

    extractSheepAndEartagData();
  }

  void extractSheepAndEartagData() {
    for (String sheepKey in possibleSheepKeysAndStrings.keys) {
      sheepData[sheepKey] = 0;
    }

    for (String eartagColor in colorStringToPossibleEartagKeys.keys) {
      if ((widget.tripData['definedEartagColors'] as List<String>)
          .contains(eartagColor)) {
        eartagData[eartagColor] = 0;
      }
    }

    for (Map<String, dynamic> registration
        in (widget.tripData['registrations']! as List<Map<String, dynamic>>)) {
      for (String sheepKey in possibleSheepKeysAndStrings.keys) {
        sheepData[sheepKey] =
            sheepData[sheepKey]! + registration[sheepKey] as int;
      }

      for (String eartagColor in colorStringToPossibleEartagKeys.keys) {
        if (eartagData[eartagColor] != null) {
          eartagData[eartagColor] = eartagData[eartagColor]! +
                  registration[colorStringToPossibleEartagKeys[eartagColor]!]!
              as int;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Padding(
          padding: const EdgeInsets.symmetric(vertical: 30),
          child: MainTripInfoTable(
            startTime: startTime,
            stopTime: stopTime,
            email: widget.tripData['personnelEmail']! as String,
            phone: widget.tripData['personnelPhone']! as String,
          )),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
              child: Padding(
            padding: const EdgeInsets.all(10),
            child: SheepInfoTable(
              sheepData: sheepData,
            ),
          )),
          Flexible(
              child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: EartagInfoTable(
                    eartagData: eartagData,
                  ))),
        ],
      ),
      Expanded(
          child: Padding(
              padding: const EdgeInsets.only(left: 30, bottom: 20, right: 30),
              child: MapOfTripWidget(
                  mapCenter: widget.tripData['mapCenter']! as LatLng,
                  track: widget.tripData['track']! as List<Map<String, double>>,
                  registrations: widget.tripData['registrations']!
                      as List<Map<String, dynamic>>)))
    ]);
  }
}
