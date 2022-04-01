import 'package:app/utils/styles.dart';
import 'package:flutter/material.dart';

class RegistrationInputHeadline extends StatelessWidget {
  const RegistrationInputHeadline({required this.title, Key? key})
      : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.centerLeft,
        child: Text(title, style: registrationFieldHeadlineTextStyle));
  }
}
