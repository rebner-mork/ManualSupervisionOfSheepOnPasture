import 'package:flutter/material.dart';

final Map<Color, int> defaultTieMap = <Color, int>{
  const Color(0xFFF44336): 0, // Red
  const Color(0xFF2196F3): 1, // Blue
  const Color(0xFFFFEB3B): 2, // Yellow
  const Color(0xFF4CAF50): 3, // Green
};

final Map<String, String> possibleTieColorStringToKey = {
  Colors.red.value.toRadixString(16): 'redTie',
  Colors.blue.value.toRadixString(16): 'blueTie',
  Colors.yellow.value.toRadixString(16): 'yellowTie',
  Colors.green.value.toRadixString(16): 'greenTie',
  Colors.orange.value.toRadixString(16): 'orangeTie',
  Colors.pink.value.toRadixString(16): 'pinkTie',
  Colors.transparent.value.toRadixString(16): 'transparentTie'
};

final Map<String, String> possibleEartagColorStringToKey = {
  Colors.red.value.toRadixString(16): 'redEar',
  Colors.blue.value.toRadixString(16): 'blueEar',
  Colors.yellow.value.toRadixString(16): 'yellowEar',
  Colors.green.value.toRadixString(16): 'greenEar',
  Colors.orange.value.toRadixString(16): 'orangeEar',
  Colors.pink.value.toRadixString(16): 'pinkEar'
};

final Map<String, String> colorValueToStringGui = {
  Colors.transparent.value.toRadixString(16): 'Ingen',
  Colors.red.value.toRadixString(16): 'Rød',
  Colors.blue.value.toRadixString(16): 'Blå',
  Colors.yellow.value.toRadixString(16): 'Gul',
  Colors.green.value.toRadixString(16): 'Grønn',
  Colors.orange.value.toRadixString(16): 'Oransje',
  Colors.pink.value.toRadixString(16): 'Rosa'
};

final Map<String, Color> colorStringToColor = {
  Colors.transparent.value.toRadixString(16): Colors.transparent,
  Colors.red.value.toRadixString(16): Colors.red,
  Colors.blue.value.toRadixString(16): Colors.blue,
  Colors.yellow.value.toRadixString(16): Colors.yellow,
  Colors.green.value.toRadixString(16): Colors.green,
  Colors.orange.value.toRadixString(16): Colors.orange,
  Colors.pink.value.toRadixString(16): Colors.pink
};

const Map<String, String> mainSheepRegistrationKeysToGui = {
  'sheep': 'Totalt',
  'lambs': 'Lam',
  'white': 'Hvite',
  'brown': 'Brune',
  'black': 'Svarte',
  'blackHead': 'Svart hode'
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

final Map<String, String> predatorEnglishKeyToNorwegianGui = <String, String>{
  "bear": "Bjørn",
  "lynx": "Gaupe",
  "wolf": "Ulv",
  "wolverine": "Jerv",
};
