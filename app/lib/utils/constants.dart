import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:camera/camera.dart';

abstract class OfflineZoomLevels {
  static double min = 16;
  static double max = 17;
}

late final String applicationDocumentDirectoryPath;
late final String offlineFarmsFilePath;

late final CameraDescription deviceCamera;

Future<void> setConstants() async {
  Directory dir = await getApplicationDocumentsDirectory();
  applicationDocumentDirectoryPath = dir.path;
  offlineFarmsFilePath = '$applicationDocumentDirectoryPath/farms.json';

  List<CameraDescription> cameras = await availableCameras();
  deviceCamera = cameras.first;
}

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

enum SheepMarkerColor { green, yellow, red }

final Map<RegistrationType, String> registrationTypeToGui = {
  RegistrationType.sheep: 'sauen(e)',
  RegistrationType.injury: 'den skadde sauen',
  RegistrationType.cadaver: 'kadaveret',
  RegistrationType.note: 'notatet'
};
