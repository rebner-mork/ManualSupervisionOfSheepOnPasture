import 'package:flutter/material.dart';
import 'package:web/utils/styles.dart';
import 'package:web/utils/constants.dart' as constants;

class PredatorTable extends StatefulWidget {
  const PredatorTable({required this.predatorData, Key? key}) : super(key: key);

  final List<Map<String, dynamic>> predatorData;

  @override
  State<PredatorTable> createState() => _PredatorTableState();
}

class _PredatorTableState extends State<PredatorTable> {
  @override
  Widget build(BuildContext context) {
    return Table(
      border: TableBorder.symmetric(
        inside: const BorderSide(width: 0.5),
      ),
      columnWidths: const {
        0: FixedColumnWidth(150),
        1: FixedColumnWidth(60),
        2: FixedColumnWidth(125)
      },
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: [
        const TableRow(children: [
          Padding(
              padding: tableCellPadding,
              child: Text('Art',
                  style: tableRowDescriptionTextStyle,
                  textAlign: TextAlign.center)),
          Padding(
              padding: tableCellPadding,
              child: Text('Antall',
                  style: tableRowDescriptionTextStyle,
                  textAlign: TextAlign.center)),
          Padding(
              padding: tableCellPadding,
              child: Text('Notat',
                  style: tableRowDescriptionTextStyle,
                  textAlign: TextAlign.center)),
        ]),
        ...widget.predatorData.map((Map<String, dynamic> registration) {
          return TableRow(
            children: [
              Padding(
                  padding: tableCellPadding,
                  child: Text(
                    '${constants.predatorEnglishKeyToNorwegianGui[registration['species']]}',
                    style: tableRowTextStyle,
                    textAlign: TextAlign.center,
                  )),
              Padding(
                  padding: tableCellPadding,
                  child: Text(
                    '${registration['quantity']}',
                    style: tableRowTextStyle,
                    textAlign: TextAlign.center,
                  )),
              Padding(
                  padding: tableCellPadding,
                  child: IconButton(
                      icon: const Icon(Icons.description),
                      color: Colors.grey.shade700,
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) => SimpleDialog(
                                  title: const Text(
                                    'Rovdyr',
                                    textAlign: TextAlign.center,
                                  ),
                                  titleTextStyle: const TextStyle(fontSize: 26),
                                  contentPadding: const EdgeInsets.fromLTRB(
                                      0.0, 1.0, 0.0, 16.0),
                                  children: [
                                    Text(
                                        (registration['note'] as String).isEmpty
                                            ? 'Ingen notat'
                                            : '${registration['note']}',
                                        style: const TextStyle(fontSize: 18),
                                        textAlign: TextAlign.center),
                                  ],
                                ));
                      }))
            ],
          );
        })
      ],
    );
  }
}
