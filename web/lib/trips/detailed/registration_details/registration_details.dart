import 'package:flutter/material.dart';
import 'package:web/trips/detailed/registration_details/cadaver_registration_details.dart';
import 'package:web/trips/detailed/registration_details/injured_sheep_registration_details.dart';
import 'package:web/trips/detailed/registration_details/sheep_registration_details.dart';

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
      case 'predator':
      /*title = 'Registrert rovdyr';
        break;*/
      case 'note':
      /*title = 'Registrert notat';
        break;*/
    }

    return const SimpleDialog(children: [Text('Det har skjedd en feil')]);
  }
}
