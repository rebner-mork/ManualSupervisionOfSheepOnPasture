import 'package:app/registration_details/cadaver_registration_details.dart';
import 'package:app/registration_details/injured_sheep_registration_details.dart';
import 'package:app/registration_details/note_registration_details.dart';
import 'package:app/registration_details/sheep_registration_details.dart';
import 'package:flutter/material.dart';

class RegistrationDetails extends StatelessWidget {
  const RegistrationDetails({required this.registration, Key? key})
      : super(key: key);

  final Map<String, dynamic> registration;

  @override
  Widget build(BuildContext context) {
    switch (registration['type']) {
      case 'sheep':
        return SheepRegistrationDetails(registration: registration);
      case 'injuredSheep':
        return InjuredSheepRegistrationDetails(registration: registration);
      case 'cadaver':
        return CadaverRegistrationDetails(registration: registration);
      /*case 'predator':*/
      /*title = 'Registrert rovdyr';
        break;*/
      case 'note':
        return NoteRegistrationDetails(registration: registration);
    }

    return const SimpleDialog(children: [Text('Det har skjedd en feil')]);
  }
}
