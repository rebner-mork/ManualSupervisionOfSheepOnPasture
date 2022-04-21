import 'package:flutter/material.dart';

class SettingsProvider extends ChangeNotifier {
  SettingsProvider(
      {this.sttAvailable,
      this.autoDialog = false,
      this.readBack = true,
      this.autoMoveMap = true});

  bool? sttAvailable;
  bool autoDialog;
  bool readBack;
  bool autoMoveMap;

  void setSttAvailability(bool available) {
    sttAvailable = available;
    notifyListeners();
  }

  void toggleAutoDialog() {
    autoDialog = !autoDialog;
    notifyListeners();
  }

  void toggleReadBack() {
    readBack = !readBack;
    notifyListeners();
  }

  void toggleAutoMoveMap() {
    autoMoveMap = !autoMoveMap;
    notifyListeners();
  }
}
