import 'package:flutter/material.dart';
import 'package:web/utils/other.dart';
import 'package:web/utils/styles.dart';

class MainTripInfoTable extends StatelessWidget {
  const MainTripInfoTable(
      {required this.startTime,
      required this.stopTime,
      required this.email,
      required this.phone,
      Key? key})
      : super(key: key);

  final String email;
  final String phone;
  final DateTime startTime;
  final DateTime stopTime;

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
        1: textSize(email, tableRowTextStyle).width > 310
            ? FixedColumnWidth(textSize(email, tableRowTextStyle).width)
            : const FixedColumnWidth(310)
      }, // FlexColumnWidths
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: [
        TableRow(children: [
          Padding(
              padding: tableCellPadding,
              child: Text('Dato', style: tableRowDescriptionTextStyle)),
          Padding(
              padding: tableCellPadding,
              child: Text(dateText(), style: tableRowTextStyle))
        ]),
        TableRow(children: [
          Padding(
              padding: tableCellPadding,
              child: Text('Tid', style: tableRowDescriptionTextStyle)),
          Padding(
              padding: tableCellPadding,
              child: Text(
                  '${startTime.hour}:${startTime.minute} - ${stopTime.hour}:${stopTime.minute}',
                  style: tableRowTextStyle))
        ]),
        TableRow(children: [
          Padding(
              padding: tableCellPadding,
              child: Text('Gått av', style: tableRowDescriptionTextStyle)),
          Padding(
              padding: tableCellPadding,
              child: Text(email + '\n' + phone, style: tableRowTextStyle))
        ]),
      ],
    );
  }
}
