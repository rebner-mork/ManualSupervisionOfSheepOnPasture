import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:web/trips/detailed/main_trip_info_table.dart';
import 'package:web/trips/detailed/map_of_trip_widget.dart';
import 'package:latlong2/latlong.dart';
import 'package:web/trips/detailed/sheep_info_table.dart';
import 'package:web/trips/detailed/info_table.dart';
import 'package:web/utils/constants.dart';
import 'package:web/utils/other.dart';

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

    for (String eartagColor in possibleEartagColorStringToKey.keys) {
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

      for (String eartagColor in possibleEartagColorStringToKey.keys) {
        if (eartagData[eartagColor] != null) {
          eartagData[eartagColor] = eartagData[eartagColor]! +
                  registration[possibleEartagColorStringToKey[eartagColor]!]!
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

  String intToMonth(int month) {
    switch (month) {
      case 1:
        return 'Januar';
      case 2:
        return 'Februar';
      case 3:
        return 'Mars';
      case 4:
        return 'April';
      case 5:
        return 'Mai';
      case 6:
        return 'Juni';
      case 7:
        return 'Juli';
      case 8:
        return 'August';
      case 9:
        return 'September';
      case 10:
        return 'Oktober';
      case 11:
        return 'November';
      case 12:
        return 'Desember';
      default:
        return '';
    }
  }

  String dateText() {
    // Same day
    if (startTime.year == stopTime.year &&
        startTime.month == stopTime.month &&
        startTime.day == stopTime.day) {
      return '${startTime.day}. ${intToMonth(startTime.month)} ${startTime.year}';
    }
    // Different day, same month
    else if (startTime.year == stopTime.year &&
        startTime.month == stopTime.month &&
        startTime.day != stopTime.day) {
      return '${startTime.day}.-${stopTime.day}. ${intToMonth(startTime.month)} ${startTime.year}';
    }
    // Different month, same year
    else if (startTime.year == stopTime.year &&
        startTime.month != stopTime.month) {
      return '${startTime.day}. ${intToMonth(startTime.month)} - ${stopTime.day}. ${intToMonth(stopTime.month)} ${stopTime.year}';
    }
    // Different year
    else {
      return '${startTime.day}. ${intToMonth(startTime.month)} ${startTime.year} - ${stopTime.day}. ${intToMonth(stopTime.month)} ${stopTime.year}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Flexible(
          flex: 3,
          child: Padding(
              padding: const EdgeInsets.only(top: 20, left: 20, bottom: 20),
              child: MapOfTripWidget(
                  mapCenter: widget.tripData['mapCenter']! as LatLng,
                  track: widget.tripData['track']! as List<Map<String, double>>,
                  registrations: widget.tripData['registrations']!
                      as List<Map<String, dynamic>>))),
      Flexible(
          flex: 2,
          child: Column(
            children: [
              SizedBox(
                  width: textSize(dateText(), const TextStyle(fontSize: 50))
                              .width >
                          410
                      ? textSize(dateText(), const TextStyle(fontSize: 50))
                          .width
                      : 410, // combined width of both InfoTables and their padding
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Text(
                          dateText(),
                          style: const TextStyle(fontSize: 50),
                        ),
                      ))),
              SizedBox(
                  width:
                      410, // combined width of both InfoTables and their padding
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        widget.tripData['mapName']! as String,
                        style: const TextStyle(
                          fontSize: 30,
                        ),
                      ))),
              Flexible(
                  child: Padding(
                      padding: const EdgeInsets.only(top: 30, bottom: 25),
                      child: MainTripInfoTable(
                        startTime: startTime,
                        stopTime: stopTime,
                        email: widget.tripData['personnelEmail']! as String,
                        phone: widget.tripData['personnelPhone']! as String,
                      ))),
              Flexible(
                  child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 30),
                child: SheepInfoTable(
                  sheepData: sheepData,
                ),
              )),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                      child: Padding(
                          padding: const EdgeInsets.only(right: 25),
                          child: InfoTable(
                              data: tieData,
                              headerText: 'Slips',
                              iconData: FontAwesome5.black_tie))),
                  Flexible(
                      child: Padding(
                          padding: const EdgeInsets.only(left: 25),
                          child: InfoTable(
                            data: eartagData,
                            headerText: 'Øremerker',
                            iconData: Icons.local_offer,
                          ))),
                ],
              ),
            ],
          )),
    ]);
  }
}
