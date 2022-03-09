import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

abstract class OfflineZoomLevels {
  static double min = 16;
  static double max = 17;
}

late final String applicationDocumentDirectoryPath;

Future<void> setConstants() async {
  Directory dir = await getApplicationDocumentsDirectory();
  applicationDocumentDirectoryPath = dir.path;
}

// TODO: se over riktig farger
Map<String, String> colorValueStringToColorString = {
  '0': 'transparent',
  'fff44336': 'red',
  'ff2196f3': 'blue',
  'ffffeb3b': 'yellow',
  'ff4caf50': 'green',
  'ffff9800': 'orange',
  'ffe91e63': 'pink'
};

Map<String, String> colorValueStringToColorStringGui = {
  '0': 'Uten',
  'fff44336': 'Røde',
  'ff2196f3': 'Blå',
  'ffffeb3b': 'Gule',
  'ff4caf50': 'Grønne',
  'ffff9800': 'Oransje',
  'ffe91e63': 'Rosa'
};

Map<String, Color> colorStringToColor = {
  '0': Colors.transparent,
  'fff44336': Colors.red,
  'ff2196f3': Colors.blue,
  'ffffeb3b': Colors.yellow,
  'ff4caf50': Colors.green,
  'ffff9800': Colors.orange,
  'ffe91e63': Colors.pink
};
