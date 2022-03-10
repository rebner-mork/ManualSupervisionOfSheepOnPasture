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

Map<String, String> colorValueStringToColorString = {
  Colors.transparent.value.toRadixString(16): 'transparent',
  Colors.red.value.toRadixString(16): 'red',
  Colors.blue.value.toRadixString(16): 'blue',
  Colors.yellow.value.toRadixString(16): 'yellow',
  Colors.green.value.toRadixString(16): 'green',
  Colors.orange.value.toRadixString(16): 'orange',
  Colors.pink.value.toRadixString(16): 'pink'
};

Map<String, String> colorValueStringToColorStringGui = {
  Colors.transparent.value.toRadixString(16): 'Uten',
  Colors.red.value.toRadixString(16): 'Røde',
  Colors.blue.value.toRadixString(16): 'Blå',
  Colors.yellow.value.toRadixString(16): 'Gule',
  Colors.green.value.toRadixString(16): 'Grønne',
  Colors.orange.value.toRadixString(16): 'Oransje',
  Colors.pink.value.toRadixString(16): 'Rosa'
};

Map<String, Color> colorStringToColor = {
  Colors.transparent.value.toRadixString(16): Colors.transparent,
  Colors.red.value.toRadixString(16): Colors.red,
  Colors.blue.value.toRadixString(16): Colors.blue,
  Colors.yellow.value.toRadixString(16): Colors.yellow,
  Colors.green.value.toRadixString(16): Colors.green,
  Colors.orange.value.toRadixString(16): Colors.orange,
  Colors.pink.value.toRadixString(16): Colors.pink
};

final Map<String, bool?> possibleEartags = {
  Colors.red.value.toRadixString(16): null,
  Colors.blue.value.toRadixString(16): null,
  Colors.yellow.value.toRadixString(16): null,
  Colors.green.value.toRadixString(16): null,
  Colors.orange.value.toRadixString(16): null,
  Colors.pink.value.toRadixString(16): null
};

final Map<String, int?> possibleTies = {
  Colors.transparent.value.toRadixString(16): null,
  Colors.red.value.toRadixString(16): null,
  Colors.blue.value.toRadixString(16): null,
  Colors.yellow.value.toRadixString(16): null,
  Colors.green.value.toRadixString(16): null,
  Colors.orange.value.toRadixString(16): null,
  Colors.pink.value.toRadixString(16): null
};
