import 'package:flutter/material.dart';

InputDecoration customInputDecoration(String labelText, IconData icon,
    {bool passwordField = false,
    bool isVisible = false,
    void Function()? onPressed}) {
  return InputDecoration(
      labelText: labelText,
      alignLabelWithHint: true,
      border: const OutlineInputBorder(),
      prefixIcon: Icon(icon),
      suffixIcon: passwordField
          ? IconButton(
              icon: Icon(isVisible ? Icons.visibility : Icons.visibility_off,
                  size: 20),
              color: isVisible ? Colors.green : Colors.grey,
              onPressed: onPressed)
          : null);
}

SizedBox inputFieldSpacer() {
  return const SizedBox(height: 18);
}

class DropdownIcon {
  DropdownIcon(IconData iconData, Color color) {
    icon = Icon(iconData, color: color);
  }

  late Icon icon;

  @override
  bool operator ==(Object other) =>
      other is DropdownIcon && other.icon.color == icon.color;

  @override
  int get hashCode => icon.hashCode;
}
