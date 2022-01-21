import 'package:flutter/material.dart';

InputDecoration customInputDecoration(String labelText, IconData icon) {
  return InputDecoration(
      labelText: labelText,
      alignLabelWithHint: true,
      border: const OutlineInputBorder(),
      prefixIcon: Align(
        widthFactor: 1.0,
        heightFactor: 1.0,
        child: Icon(icon),
      ));
}
