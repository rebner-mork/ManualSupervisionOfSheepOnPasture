import 'dart:convert';
import 'dart:io';

import 'package:app/utils/constants.dart';
import 'package:flutter/material.dart';

Map<String, bool> defaultSettings = {
  'autoDialog': false,
  'readBack': true,
  'autoMoveMap': true
};

class SettingsProvider extends ChangeNotifier {
  SettingsProvider({this.sttAvailable}) {
    Map<String, bool> settings;

    if (File(settingsFilePath).existsSync()) {
      settings = (jsonDecode(File(settingsFilePath).readAsStringSync()) as Map)
          .map((key, value) => MapEntry(key, value));
    } else {
      settings = defaultSettings;
      File(settingsFilePath).writeAsStringSync(jsonEncode(settings));
    }

    autoDialog = settings['autoDialog']!;
    readBack = settings['readBack']!;
    autoMoveMap = settings['autoMoveMap']!;
  }

  bool? sttAvailable;
  late bool autoDialog;
  late bool readBack;
  late bool autoMoveMap;

  void setSttAvailability(bool available) {
    sttAvailable = available;
    notifyListeners();
  }

  void toggleAutoDialog() {
    autoDialog = !autoDialog;
    writeSettings();
    notifyListeners();
  }

  void toggleReadBack() {
    readBack = !readBack;
    writeSettings();
    notifyListeners();
  }

  void toggleAutoMoveMap() {
    autoMoveMap = !autoMoveMap;
    writeSettings();
    notifyListeners();
  }

  void writeSettings() {
    File(settingsFilePath).writeAsString(jsonEncode({
      'autoDialog': autoDialog,
      'readBack': readBack,
      'autoMoveMap': autoMoveMap
    }));
  }
}
