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

final Map<String, String> colorValueStringToColorString = {
  Colors.transparent.value.toRadixString(16): 'transparent',
  Colors.red.value.toRadixString(16): 'red',
  Colors.blue.value.toRadixString(16): 'blue',
  Colors.yellow.value.toRadixString(16): 'yellow',
  Colors.green.value.toRadixString(16): 'green',
  Colors.orange.value.toRadixString(16): 'orange',
  Colors.pink.value.toRadixString(16): 'pink'
};

final Map<String, String> colorValueStringToColorStringGuiPlural = {
  Colors.transparent.value.toRadixString(16): 'Ingen',
  Colors.red.value.toRadixString(16): 'Røde',
  Colors.blue.value.toRadixString(16): 'Blå',
  Colors.yellow.value.toRadixString(16): 'Gule',
  Colors.green.value.toRadixString(16): 'Grønne',
  Colors.orange.value.toRadixString(16): 'Oransje',
  Colors.pink.value.toRadixString(16): 'Rosa'
};

final Map<String, String> colorValueToStringGui = {
  Colors.transparent.value.toRadixString(16): 'Ingen',
  Colors.red.value.toRadixString(16): 'Rødt',
  Colors.blue.value.toRadixString(16): 'Blått',
  Colors.yellow.value.toRadixString(16): 'Gult',
  Colors.green.value.toRadixString(16): 'Grønt',
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

final Map<String, bool?> possibleEartagsWithoutDefinition = {
  Colors.red.value.toRadixString(16): null,
  Colors.blue.value.toRadixString(16): null,
  Colors.yellow.value.toRadixString(16): null,
  Colors.green.value.toRadixString(16): null,
  Colors.orange.value.toRadixString(16): null,
  Colors.pink.value.toRadixString(16): null
};

final Map<String, int?> possibleTiesWithoutDefinition = {
  Colors.transparent.value.toRadixString(16): null,
  Colors.red.value.toRadixString(16): null,
  Colors.blue.value.toRadixString(16): null,
  Colors.yellow.value.toRadixString(16): null,
  Colors.green.value.toRadixString(16): null,
  Colors.orange.value.toRadixString(16): null,
  Colors.pink.value.toRadixString(16): null
};

enum RegistrationType { sheep, injury, cadaver, predator, note }

final Map<RegistrationType, String> registrationTypeToGui = {
  RegistrationType.sheep: 'sauen',
  RegistrationType.injury: 'den skadde sauen',
  RegistrationType.cadaver: 'kadaveret',
  RegistrationType.note: 'notatet'
};
