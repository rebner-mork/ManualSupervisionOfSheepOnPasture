import 'package:flutter/material.dart';
import 'package:web/utils/constants.dart';
import 'package:web/utils/styles.dart';

class EartagInfoTable extends StatelessWidget {
  const EartagInfoTable(
      {required this.registrations,
      required this.definedEartagColors,
      required this.definedTieColors,
      Key? key})
      : super(key: key);

  final List<Map<String, dynamic>> registrations;
  final List<String> definedEartagColors;
  final List<String> definedTieColors;

  @override
  Widget build(BuildContext context) {
    return Table(
        border: TableBorder.symmetric(
            outside: const BorderSide(), inside: const BorderSide(width: 0.5)),
        //columnWidths,
        children: [
          TableRow(children: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text('Øremerker', style: tableRowDescriptionTextStyle),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text('Antall', style: tableRowDescriptionTextStyle),
            )
          ]),
          ...definedEartagColors
              .asMap()
              .entries
              .map((MapEntry<int, String> mapEntry) => TableRow(children: [
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Row(children: [
                        Icon(
                          Icons.local_offer,
                          color: colorStringToColor[
                              definedEartagColors[mapEntry.key]],
                        ),
                        Text(
                            colorValueToString[int.parse(
                                definedEartagColors[mapEntry.key],
                                radix: 16)]!,
                            style: tableRowTextStyle)
                      ]),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text('', style: tableRowTextStyle),
                    )
                  ]))
              .toList()
        ]);
  }
}
