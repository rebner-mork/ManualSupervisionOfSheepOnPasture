import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:web/utils/other.dart';
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

  @override
  void initState() {
    super.initState();
    startTime = (widget.tripData['startTime']! as Timestamp).toDate();
    stopTime = (widget.tripData['stopTime']! as Timestamp).toDate();
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
    return Table(
      border: TableBorder.symmetric(
          outside: const BorderSide(), inside: const BorderSide(width: 0.5)),
      columnWidths: {
        0: const FixedColumnWidth(70),
        1: textSize(widget.tripData['personnelEmail'].toString(), tableRowText)
                    .width >
                310
            ? FixedColumnWidth(textSize(
                    widget.tripData['personnelEmail'].toString(), tableRowText)
                .width)
            : const FixedColumnWidth(310)
      }, // FlexColumnWidths
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: [
        TableRow(children: [
          Padding(
              padding: const EdgeInsets.all(8),
              child: Text('Dato', style: tableRowDescription)),
          Padding(
              padding: const EdgeInsets.all(8),
              child: Text(dateText(), style: tableRowText))
        ]),
        TableRow(children: [
          Padding(
              padding: const EdgeInsets.all(8),
              child: Text('Tid', style: tableRowDescription)),
          Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                  '${startTime.hour}:${startTime.minute} - ${stopTime.hour}:${stopTime.minute}',
                  style: tableRowText))
        ]),
        TableRow(children: [
          Padding(
              padding: const EdgeInsets.all(8),
              child: Text('Gått av', style: tableRowDescription)),
          Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                  widget.tripData['personnelEmail']!.toString() +
                      '\n' +
                      widget.tripData['personnelPhone'].toString(),
                  style: tableRowText))
        ]),
      ],
    );
  }
}
