import 'package:flutter/material.dart';

const List<Color> possibleColors = [
  Color(0xFFF44336), // Red
  Color(0xFF2196F3), // Blue
  Color(0xFFFFEB3B), // Yellow
  Color(0xFF4CAF50), // Green
  Color(0xFFFF9800), // Orange
  Color(0xFFE91E63), // Pink
  Color(0x00000000), // Transparent
];

const Map<int, Color> colorValueToColor = {
  4294198070: Colors.red,
  4280391411: Colors.blue,
  4294961979: Colors.yellow,
  4283215696: Colors.green,
  4294940672: Colors.orange,
  4293467747: Colors.pink
};

const Map<int, String> colorValueToString = {
  4294198070: 'Rød',
  4280391411: 'Blå',
  4294961979: 'Gul',
  4283215696: 'Grønn',
  4294940672: 'Oransje',
  4293467747: 'Rosa',
  0: 'Ingen'
};

final Map<Color, String> colorToString = <Color, String>{
  Colors.red: 'Rød',
  Colors.blue: 'Blå',
  Colors.yellow: 'Gul',
  Colors.green: 'Grønn',
  Colors.orange: 'Oransje',
  Colors.pink: 'Rosa',
  Colors.transparent: 'Ingen'
};

final Map<Color, String> dialogColorToString = <Color, String>{
  const Color(0xFFF44336): 'rødt',
  const Color(0xFF2196F3): 'blått',
  const Color(0xFFFFEB3B): 'gult',
  const Color(0xFF4CAF50): 'grønt',
  const Color(0xFFFF9800): 'oransje',
  const Color(0xFFE91E63): 'rosa',
  const Color(0x00000000): '\'ingen\''
};

final Map<Color, int> defaultTieMap = <Color, int>{
  const Color(0xFFF44336): 0, // Red
  const Color(0xFF2196F3): 1, // Blue
  const Color(0xFFFFEB3B): 2, // Yellow
  const Color(0xFF4CAF50): 3, // Green
};
