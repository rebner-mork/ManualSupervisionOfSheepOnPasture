import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:web/trips/detailed/injured_sheep_table.dart';
import 'package:web/trips/detailed/main_trip_info_table.dart';
import 'package:web/trips/detailed/map_of_trip_widget.dart';
import 'package:latlong2/latlong.dart';
import 'package:web/trips/detailed/sheep_info_table.dart';
import 'package:web/trips/detailed/info_table.dart';
import 'package:web/utils/constants.dart';
import 'package:web/utils/other.dart';
import 'package:web/utils/styles.dart';

const TextStyle injuredSheepHeadlineTextStyle =
    TextStyle(fontSize: 22, fontWeight: FontWeight.bold);

const TextStyle mainHeadlineTextStyle = TextStyle(fontSize: 50);
const TextStyle mapHeadlineTextStyle = TextStyle(
  fontSize: 30,
);
const TextStyle headlineTextStyle = TextStyle(fontSize: 24);

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
  List<Map<String, dynamic>> injuredSheepData = [];
  Map<String, int> eartagData = {};
  Map<String, int> tieData = {};

  final double infoTablePadding = 25;

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    startTime = (widget.tripData['startTime']! as Timestamp).toDate();
    stopTime = (widget.tripData['stopTime']! as Timestamp).toDate();

    _initDataMaps();
    _fillDataMaps();
  }

  void _initDataMaps() {
    for (String sheepKey in mainSheepRegistrationKeysToGui.keys) {
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
    debugPrint(widget.tripData['registrations'].toString());
    for (Map<String, dynamic> registration
        in (widget.tripData['registrations']! as List<Map<String, dynamic>>)) {
      switch (registration['type']) {
        case 'sheep':
          _fillDataMapsFromSheepRegistration(registration);
          break;
        case 'injuredSheep':
          injuredSheepData.add(registration);
          sheepData['sheep'] = sheepData['sheep']! + 1;
          break;
        default:
      }
    }
  }

  void _fillDataMapsFromSheepRegistration(Map<String, dynamic> registration) {
    for (String sheepKey in mainSheepRegistrationKeysToGui.keys) {
      sheepData[sheepKey] =
          sheepData[sheepKey]! + registration[sheepKey] as int;
    }

    for (String eartagColor in possibleEartagColorStringToKey.keys) {
      if (eartagData[eartagColor] != null &&
          registration[possibleEartagColorStringToKey[eartagColor]!] != null) {
        eartagData[eartagColor] = eartagData[eartagColor]! +
            registration[possibleEartagColorStringToKey[eartagColor]!]! as int;
      }
    }

    for (String tieColor in possibleTieColorStringToKey.keys) {
      if (tieData[tieColor] != null &&
          registration[possibleTieColorStringToKey[tieColor]!] != null) {
        tieData[tieColor] = tieData[tieColor]! +
            registration[possibleTieColorStringToKey[tieColor]!]! as int;
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
        throw Exception(
            'Invalid month: Month has to be in inclusive range 1-12 (was $month)');
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

  double _computeHeight() {
    double height = 0;

    // Date-headline
    height += 20 + textSize('2022', mainHeadlineTextStyle).height;

    // Mapname
    height += textSize('2022', mapHeadlineTextStyle).height;

    // MainTripInfoTable
    height += 50 +
        2 *
            (textSize('A', descriptionTextStyle).height +
                (2 * tableCellPadding.top));

    // SheepInfoTableHeight
    height += 2 *
        (textSize('A', tableRowDescriptionTextStyle).height +
            (2 * tableCellPadding.top));

    // InfoTableHeight
    height += textSize(('A'), headlineTextStyle).width +
        40 +
        textSize('A', tableRowDescriptionTextStyle).height +
        (2 * tableCellPadding.top) +
        (tieData.length > eartagData.length
            ? tieData.length * (25 + (2 * tableCellPadding.top))
            : eartagData.length * (25 + (2 * tableCellPadding.top)));

    // InjuredSheepTable
    if (injuredSheepData.isNotEmpty) {
      height += textSize(('A'), headlineTextStyle).width +
          40 +
          textSize('S', injuredSheepHeadlineTextStyle).height +
          textSize('A', descriptionTextStyle).height +
          (2 * tableCellPadding.top) +
          injuredSheepData.length * (41 + (2 * tableCellPadding.top));
    }

    return height;
  }

  // TODO: notat-popup kryss

  @override
  Widget build(BuildContext context) {
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
          child: SingleChildScrollView(
              controller: _scrollController,
              child: SizedBox(
                  height: _computeHeight(),
                  child: Column(
                    children: [
                      SizedBox(
                          width: textSize(dateText(), mainHeadlineTextStyle)
                                      .width >
                                  (2 * (infoTableWidth + infoTablePadding))
                              ? textSize(dateText(), mainHeadlineTextStyle)
                                  .width
                              : 2 * (infoTableWidth + infoTablePadding),
                          child: Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 20),
                                child: Text(
                                  dateText(),
                                  style: mainHeadlineTextStyle,
                                ),
                              ))),
                      SizedBox(
                          width: 2 * (infoTableWidth + infoTablePadding),
                          child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(widget.tripData['mapName']! as String,
                                  style: mapHeadlineTextStyle))),
                      Padding(
                          padding: const EdgeInsets.only(top: 25, bottom: 25),
                          child: MainTripInfoTable(
                              startTime: startTime,
                              stopTime: stopTime,
                              personnelName:
                                  widget.tripData['personnelName']! as String)),
                      SheepInfoTable(
                        sheepData: sheepData,
                      ),
                      const Headline(title: 'Øremerker & Slips'),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Flexible(
                              child: Padding(
                                  padding:
                                      EdgeInsets.only(right: infoTablePadding),
                                  child: InfoTable(
                                      data: tieData,
                                      headerText: 'Slips',
                                      iconData: FontAwesome5.black_tie))),
                          Flexible(
                              child: Padding(
                                  padding:
                                      EdgeInsets.only(left: infoTablePadding),
                                  child: InfoTable(
                                    data: eartagData,
                                    headerText: 'Øremerker',
                                    iconData: Icons.local_offer,
                                  ))),
                        ],
                      ),
                      if (injuredSheepData.isNotEmpty)
                        const Headline(title: 'Skader'),
                      if (injuredSheepData.isNotEmpty)
                        InjuredSheepTable(injuredSheep: injuredSheepData)
                    ],
                  )))),
    ]);
  }
}

class Headline extends StatelessWidget {
  const Headline({required this.title, this.padding = 25, Key? key})
      : super(key: key);

  final String title;
  final double padding;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 2 * (infoTableWidth + padding),
        child: Padding(
            padding: const EdgeInsets.only(top: 25, bottom: 15),
            child: Text(title, style: headlineTextStyle)));
  }
}
