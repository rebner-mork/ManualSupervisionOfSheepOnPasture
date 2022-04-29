import 'package:flutter/material.dart';
import 'package:app/utils/constants.dart';
import 'package:app/registration_details/timestamp_widget.dart';
import 'package:app/utils/styles.dart';

class PredatorRegistrationDetails extends StatelessWidget {
  const PredatorRegistrationDetails({required this.registration, Key? key})
      : super(key: key);

  final Map<String, dynamic> registration;

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      contentPadding: const EdgeInsets.fromLTRB(5.0, 5.0, 10.0, 10.0),
      title: const Text('Rovdyr',
          style: dialogHeadlineTextStyle, textAlign: TextAlign.center),
      children: [
        Center(
            child: Table(
                columnWidths: const {
                  0: FixedColumnWidth(80),
                  1: FixedColumnWidth(80)
                },
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                children: [
                  TableRow(children: [
                    const Padding(
                      padding: tableCellPadding,
                      child: Text('Art',
                          style: registrationDetailsDescriptionTextStyle,
                          textAlign: TextAlign.left),
                    ),
                    Padding(
                        padding: tableCellPadding,
                        child: Text(
                            predatorEnglishKeyToNorwegianGui[
                                registration['species']]!,
                            style: registrationDetailsDescriptionTextStyle))
                  ]),
                  TableRow(children: [
                    const Padding(
                      padding: tableCellPadding,
                      child: Text('Antall',
                          style: registrationDetailsDescriptionTextStyle,
                          textAlign: TextAlign.left),
                    ),
                    Padding(
                        padding: tableCellPadding,
                        child: Text('${registration['quantity']}',
                            style: registrationDetailsDescriptionTextStyle))
                  ])
                ])),
        const SizedBox(height: 15),
        Container(
            constraints:
                const BoxConstraints(maxWidth: registrationNoteWidthWide),
            child: Text(
                (registration['note'] as String).isEmpty
                    ? 'Ingen notat'
                    : '${registration['note']}',
                style: registrationNoteTextStyle,
                textAlign: TextAlign.center)),
        const SizedBox(height: 20),
        TimestampWidget(date: registration['timestamp'])
      ],
    );
  }
}
