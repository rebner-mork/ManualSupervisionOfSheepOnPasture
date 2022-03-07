import 'package:flutter/material.dart';

class SettingsProvider extends ChangeNotifier {
  SettingsProvider(
      {this.sttAvailable, this.autoDialog = false, this.readBack = true});

  bool? sttAvailable;
  bool autoDialog;
  bool readBack;

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
}
