import 'dart:convert';
import 'dart:io';

import 'package:app/utils/constants.dart';
import 'package:flutter/material.dart';

class SettingsProvider extends ChangeNotifier {
  SettingsProvider({required Map<String, bool> settings, this.sttAvailable}) {
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
    writeSettings();
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
