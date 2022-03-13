import 'package:flutter/material.dart';
import 'package:web/utils/styles.dart';

class SheepInfoTable extends StatelessWidget {
  const SheepInfoTable(
      {required this.sheepAmount,
      required this.lambAmount,
      required this.whiteAmount,
      required this.blackAmount,
      required this.blackHeadAmount,
      Key? key})
      : super(key: key);

  final int sheepAmount;
  final int lambAmount;
  final int whiteAmount;
  final int blackAmount;
  final int blackHeadAmount;

  @override
  Widget build(BuildContext context) {
    return Table(
        border: TableBorder.symmetric(
            outside: const BorderSide(), inside: const BorderSide(width: 0.5)),
        columnWidths: const {
          0: FixedColumnWidth(95),
          1: FixedColumnWidth(70)
        },
        children: [
          TableRow(children: [
            Padding(
              padding: tableCellPadding,
              child: const Text(
                '',
              ),
            ),
            Padding(
              padding: tableCellPadding,
              child: Text(
                'Antall',
                style: tableRowDescriptionTextStyle,
                textAlign: TextAlign.center,
              ),
            )
          ]),
          TableRow(children: [
            Padding(
              padding: tableCellPadding,
              child: Text(
                'Totalt',
                style: tableRowDescriptionTextStyle,
              ),
            ),
            Padding(
              padding: tableCellPadding,
              child: Text(
                sheepAmount.toString(),
                style: tableRowDescriptionTextStyle,
                textAlign: TextAlign.center,
              ),
            )
          ]),
          TableRow(children: [
            Padding(
              padding: tableCellPadding,
              child: Text(
                'Lam',
                style: tableRowDescriptionTextStyle,
              ),
            ),
            Padding(
              padding: tableCellPadding,
              child: Text(
                lambAmount.toString(),
                style: tableRowTextStyle,
                textAlign: TextAlign.center,
              ),
            )
          ]),
          TableRow(children: [
            Padding(
              padding: tableCellPadding,
              child: Text(
                'Hvite',
                style: tableRowDescriptionTextStyle,
              ),
            ),
            Padding(
              padding: tableCellPadding,
              child: Text(
                whiteAmount.toString(),
                style: tableRowTextStyle,
                textAlign: TextAlign.center,
              ),
            )
          ]),
          TableRow(children: [
            Padding(
              padding: tableCellPadding,
              child: Text(
                'Svarte',
                style: tableRowDescriptionTextStyle,
              ),
            ),
            Padding(
              padding: tableCellPadding,
              child: Text(
                blackAmount.toString(),
                style: tableRowTextStyle,
                textAlign: TextAlign.center,
              ),
            )
          ]),
          TableRow(children: [
            Padding(
              padding: tableCellPadding,
              child: Text(
                'Svart hode',
                style: tableRowDescriptionTextStyle,
              ),
            ),
            Padding(
              padding: tableCellPadding,
              child: Text(
                blackHeadAmount.toString(),
                style: tableRowTextStyle,
                textAlign: TextAlign.center,
              ),
            )
          ]),
        ]);
  }
}
