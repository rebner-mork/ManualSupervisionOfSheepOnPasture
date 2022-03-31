import 'package:flutter/material.dart';

class RadioButton extends StatelessWidget {
  const RadioButton(
      {required this.value,
      required this.groupValue,
      required this.onChanged,
      Key? key})
      : super(key: key);

  final bool value;
  final bool groupValue;
  final Function(bool?) onChanged;

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
        scale: 1.6,
        child: Radio<bool>(
            value: value,
            groupValue: groupValue,
            activeColor: Colors.green,
            onChanged: onChanged));
  }
}
