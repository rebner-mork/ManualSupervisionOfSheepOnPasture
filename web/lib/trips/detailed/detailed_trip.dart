import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:web/trips/detailed/main_trip_info_table.dart';
import 'package:web/trips/detailed/map_of_trip_widget.dart';
import 'package:latlong2/latlong.dart';
import 'package:web/trips/detailed/sheep_info_table.dart';
import 'package:web/trips/detailed/info_table.dart';
import 'package:web/utils/constants.dart';

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
  Map<String, int> tieData = {};

  @override
  void initState() {
    super.initState();
    startTime = (widget.tripData['startTime']! as Timestamp).toDate();
    stopTime = (widget.tripData['stopTime']! as Timestamp).toDate();

    _initDataMaps();
    _fillDataMaps();
  }

  void _initDataMaps() {
    for (String sheepKey in possibleSheepKeysAndStrings.keys) {
      sheepData[sheepKey] = 0;
    }

    for (String eartagColor in colorStringToPossibleEartagKeys.keys) {
      if ((widget.tripData['definedEartagColors'] as List<String>)
          .contains(eartagColor)) {
        eartagData[eartagColor] = 0;
      }
    }

    for (String tieColor in possibleTieColorStringToKey.keys) {
      if ((widget.tripData['definedTieColors'] as List<String>)
          .contains(tieColor)) {
        tieData[tieColor] = 0;
      }
    }
  }

  void _fillDataMaps() {
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

      for (String tieColor in possibleTieColorStringToKey.keys) {
        if (tieData[tieColor] != null) {
          tieData[tieColor] = tieData[tieColor]! +
              registration[possibleTieColorStringToKey[tieColor]!]! as int;
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
                  child: InfoTable(
                    data: eartagData,
                    headerText: 'Øremerker',
                    iconData: Icons.local_offer,
                  ))),
          Flexible(
              child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: InfoTable(
                      data: tieData,
                      headerText: 'Slips',
                      iconData: FontAwesome5.black_tie)))
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
