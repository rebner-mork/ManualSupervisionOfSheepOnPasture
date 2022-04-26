import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:web/utils/constants.dart';
import 'package:web/utils/styles.dart';

class InjuredSheepRegistrationDetails extends StatelessWidget {
  InjuredSheepRegistrationDetails({required this.registration, Key? key})
      : super(key: key) {
    eartag = (registration['eartag'] as String).split('-');
  }

  final Map<String, dynamic> registration;
  late final List<String> eartag;

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      contentPadding: const EdgeInsets.fromLTRB(10.0, 1.0, 0.0, 16.0),
      title: const Text('Saueskade',
          style: dialogHeadlineTextStyle, textAlign: TextAlign.center),
      children: [
        Text('${eartag[0]}-${eartag[1]}\n${eartag[2]}-${eartag[3]}',
            style: const TextStyle(fontSize: 20), textAlign: TextAlign.center),
        const SizedBox(height: 20),
        Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Table(
              columnWidths: const {
                0: FixedColumnWidth(70),
                1: FixedColumnWidth(95)
              },
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: [
                TableRow(children: [
                  const Padding(
                      padding: tableCellPadding,
                      child: Text('Slips',
                          style: registrationDetailsDescriptionTextStyle,
                          textAlign: TextAlign.left)),
                  Padding(
                      padding: tableCellPadding,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                                colorValueToStringGui[
                                    '${registration['tieColor']}']!,
                                style: registrationDetailsDescriptionTextStyle),
                            Icon(
                              registration['tieColor'] == '0'
                                  ? Icons.disabled_by_default
                                  : FontAwesome.black_tie,
                              size: 30,
                              color: registration['tieColor'] == '0'
                                  ? Colors.grey
                                  : Color(int.parse(registration['tieColor'],
                                      radix: 16)),
                            ),
                          ])),
                ]),
                TableRow(children: [
                  const Padding(
                      padding: tableCellPadding,
                      child: Text('Type',
                          style: registrationDetailsDescriptionTextStyle,
                          textAlign: TextAlign.left)),
                  Padding(
                      padding: tableCellPadding,
                      child: Text(
                        '${registration['injuryType']}',
                        style: registrationDetailsDescriptionTextStyle,
                        textAlign: TextAlign.left,
                      )),
                ]),
                TableRow(children: [
                  const Padding(
                      padding: tableCellPadding,
                      child: Text('Alvorlighet',
                          style: registrationDetailsDescriptionTextStyle,
                          textAlign: TextAlign.left)),
                  Padding(
                      padding: tableCellPadding,
                      child: Text(
                        '${registration['severity']}',
                        style: registrationDetailsDescriptionTextStyle,
                        textAlign: TextAlign.left,
                      )),
                ])
              ],
            )),
        const SizedBox(height: 10),
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            child: SizedBox(
                width: 250,
                child: Text(
                    (registration['note'] as String).isEmpty
                        ? 'Ingen notat.'
                        : '${registration['note']}',
                    style: const TextStyle(fontSize: 18),
                    textAlign: TextAlign.center)))
      ],
    );
  }
}
