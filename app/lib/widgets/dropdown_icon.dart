import 'package:flutter/material.dart';

class DropdownIcon {
  DropdownIcon(IconData iconData, Color color) {
    icon = Icon(
      iconData,
      color: color,
      size: 40,
    );
  }

  late Icon icon;

  @override
  bool operator ==(Object other) =>
      other is DropdownIcon && other.icon.color == icon.color;

  @override
  int get hashCode => icon.hashCode;
}
