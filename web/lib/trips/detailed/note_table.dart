import 'package:flutter/material.dart';
import 'package:web/utils/styles.dart';

const double noteTableWidth = 515;
const TextStyle noteTableTextStyle = TextStyle(fontSize: 14);

class NoteTable extends StatelessWidget {
  const NoteTable({required this.data, Key? key}) : super(key: key);

  final List<String> data;

  @override
  Widget build(BuildContext context) {
    return Table(
        border: TableBorder.symmetric(
            outside: const BorderSide(width: 0.5),
            inside: const BorderSide(width: 0.35)),
        columnWidths: const {
          0: FixedColumnWidth(noteTableWidth)
        },
        children: [
          ...data
              .map((String note) => TableRow(children: [
                    Padding(
                      padding: tableCellPadding,
                      child: Text(
                        note,
                        style: noteTableTextStyle,
                        textAlign: TextAlign.center,
                      ),
                    )
                  ]))
              .toList()
        ]);
  }
}
