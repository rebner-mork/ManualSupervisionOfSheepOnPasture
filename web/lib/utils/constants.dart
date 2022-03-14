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

const Map<String, String> possibleSheepKeysAndStrings = {
  'sheep': 'Totalt',
  'lambs': 'Lam',
  'white': 'Hvite',
  'black': 'Svarte',
  'blackHead': 'Svart hode'
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

final Map<Color, String> dialogColorToString = <Color, String>{
  const Color(0xFFF44336): 'rødt',
  const Color(0xFF2196F3): 'blått',
  const Color(0xFFFFEB3B): 'gult',
  const Color(0xFF4CAF50): 'grønt',
  const Color(0xFFFF9800): 'oransje',
  const Color(0xFFE91E63): 'rosa',
  const Color(0x00000000): '\'ingen\''
};
