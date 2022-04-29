import 'package:flutter/material.dart';
import 'package:web/trips/detailed/registration_details/timestamp_widget.dart';
import 'package:web/utils/styles.dart';

class NoteRegistrationDetails extends StatelessWidget {
  const NoteRegistrationDetails({required this.registration, Key? key})
      : super(key: key);

  final Map<String, dynamic> registration;

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      contentPadding: const EdgeInsets.fromLTRB(10.0, 10.0, 25.0, 10.0),
      title: const Text('Notat',
          style: dialogHeadlineTextStyle, textAlign: TextAlign.center),
      children: [
        Container(
            constraints:
                const BoxConstraints(maxWidth: registrationNoteWidthWide),
            child: Text(registration['note'],
                style: TextStyle(
                    fontSize: registrationNoteTextStyle.fontSize! - 2),
                textAlign: TextAlign.center)),
        const SizedBox(height: 10),
        TimestampWidget(timestamp: registration['timestamp'])
      ],
    );
  }
}
