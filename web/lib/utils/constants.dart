import 'package:flutter/material.dart';

final Map<Color, int> defaultTieMap = <Color, int>{
  const Color(0xFFF44336): 0, // Red
  const Color(0xFF2196F3): 1, // Blue
  const Color(0xFFFFEB3B): 2, // Yellow
  const Color(0xFF4CAF50): 3, // Green
};

const List<Color> possibleTieColors = [
  Color(0xFFF44336), // Red
  Color(0xFF2196F3), // Blue
  Color(0xFFFFEB3B), // Yellow
  Color(0xFF4CAF50), // Green
  Color(0xFFFF9800), // Orange
  Color(0xFFE91E63), // Pink
  Color(0x00000000), // Transparent
];

const List<Color> possibleEartagColors = [
  Color(0xFFF44336), // Red
  Color(0xFF2196F3), // Blue
  Color(0xFFFFEB3B), // Yellow
  Color(0xFF4CAF50), // Green
  Color(0xFFFF9800), // Orange
  Color(0xFFE91E63), // Pink
];

final Map<int, Color> colorValueToColor = {
  Colors.red.value: Colors.red,
  Colors.blue.value: Colors.blue,
  Colors.yellow.value: Colors.yellow,
  Colors.green.value: Colors.green,
  Colors.orange.value: Colors.orange,
  Colors.pink.value: Colors.pink
};

final Map<int, String> colorValueToString = {
  Colors.red.value: 'Rød',
  Colors.blue.value: 'Blå',
  Colors.yellow.value: 'Gul',
  Colors.green.value: 'Grønn',
  Colors.orange.value: 'Oransje',
  Colors.pink.value: 'Rosa',
  Colors.transparent.value: 'Ingen'
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
