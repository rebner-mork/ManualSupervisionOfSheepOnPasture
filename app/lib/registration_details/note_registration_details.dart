import 'package:app/registration_details/timestamp_widget.dart';
import 'package:app/utils/styles.dart';
import 'package:flutter/material.dart';

class NoteRegistrationDetails extends StatelessWidget {
  const NoteRegistrationDetails({required this.registration, Key? key})
      : super(key: key);

  final Map<String, dynamic> registration;

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      contentPadding: const EdgeInsets.fromLTRB(10.0, 32.0, 25.0, 10.0),
      title: const Text('Notat',
          style: dialogHeadlineTextStyle, textAlign: TextAlign.center),
      children: [
        Text(registration['note'],
            style: registrationDetailsDescriptionTextStyle),
        const SizedBox(height: 10),
        TimestampWidget(date: registration['timestamp'])
      ],
    );
  }
}
