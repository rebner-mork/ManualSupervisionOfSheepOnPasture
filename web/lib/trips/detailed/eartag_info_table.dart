import 'package:flutter/material.dart';
import 'package:web/utils/constants.dart';
import 'package:web/utils/styles.dart';

class EartagInfoTable extends StatelessWidget {
  const EartagInfoTable({required this.eartagData, Key? key}) : super(key: key);

  final Map<String, int> eartagData;

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
              child: Text('Øremerker',
                  style: tableRowDescriptionTextStyle,
                  textAlign: TextAlign.center),
            ),
            Padding(
              padding: tableCellPadding,
              child: Text('Antall',
                  style: tableRowDescriptionTextStyle,
                  textAlign: TextAlign.center),
            )
          ]),
          ...eartagData.entries
              .map((MapEntry<String, int> mapEntry) => TableRow(children: [
                    Padding(
                      padding: tableCellPadding,
                      child: Row(children: [
                        Icon(
                          Icons.local_offer,
                          color: colorStringToColor[mapEntry.key],
                        ),
                        Text(
                            colorValueToString[
                                int.parse(mapEntry.key, radix: 16)]!,
                            style: tableRowTextStyle,
                            textAlign: TextAlign.center)
                      ]),
                    ),
                    Padding(
                      padding: tableCellPadding,
                      child: Text(mapEntry.value.toString(),
                          style: tableRowTextStyle),
                    )
                  ]))
              .toList(),
        ]);
  }
}
