import 'package:flutter/material.dart';
import 'package:web/utils/constants.dart';
import 'package:web/utils/styles.dart';

class SheepInfoTable extends StatelessWidget {
  const SheepInfoTable({required this.sheepData, Key? key}) : super(key: key);

  final Map<String, int> sheepData;

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
          ...sheepData.entries
              .map(
                (MapEntry<String, int> mapEntry) => TableRow(children: [
                  Padding(
                    padding: tableCellPadding,
                    child: Text(
                      possibleSheepKeysAndStrings[mapEntry.key]!,
                      style:
                          tableRowDescriptionTextStyle, // TODO: bold på alle eller bare første eller ingen?
                    ),
                  ),
                  Padding(
                    padding: tableCellPadding,
                    child: Text(
                      mapEntry.value.toString(),
                      style: tableRowDescriptionTextStyle,
                      textAlign: TextAlign.center,
                    ),
                  )
                ]),
              )
              .toList(),
        ]);
  }
}
