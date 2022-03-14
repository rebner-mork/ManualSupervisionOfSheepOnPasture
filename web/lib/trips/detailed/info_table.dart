import 'package:flutter/material.dart';
import 'package:web/utils/constants.dart';
import 'package:web/utils/styles.dart';

class InfoTable extends StatelessWidget {
  const InfoTable(
      {required this.data,
      required this.headerText,
      required this.iconData,
      Key? key})
      : super(key: key);

  final Map<String, int> data;
  final String headerText;
  final IconData iconData;

  @override
  Widget build(BuildContext context) {
    return Table(
        border: TableBorder.symmetric(
            outside: const BorderSide(), inside: const BorderSide(width: 0.5)),
        columnWidths: const {
          0: FixedColumnWidth(105),
          1: FixedColumnWidth(70)
        },
        children: [
          TableRow(children: [
            Padding(
              padding: tableCellPadding,
              child: Text(headerText,
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
          ...data.entries
              .map((MapEntry<String, int> mapEntry) => TableRow(children: [
                    Padding(
                      padding: tableCellPadding,
                      child: Row(children: [
                        Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: Icon(
                              iconData,
                              color: Color(int.parse(mapEntry.key, radix: 16)),
                            )),
                        Text(
                            colorValueToString[
                                int.parse(mapEntry.key, radix: 16)]!,
                            style: tableRowTextStyle,
                            textAlign: TextAlign.center)
                      ]),
                    ),
                    Padding(
                      padding: tableCellPadding,
                      child: Text(
                        mapEntry.value.toString(),
                        style: tableRowTextStyle,
                        textAlign: TextAlign.center,
                      ),
                    )
                  ]))
              .toList(),
        ]);
  }
}
