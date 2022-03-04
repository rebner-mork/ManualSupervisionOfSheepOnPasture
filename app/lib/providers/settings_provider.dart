import 'package:flutter/material.dart';

class SettingsProvider extends ChangeNotifier {
  SettingsProvider({this.autoDialog = true, this.readBack = true});

  bool autoDialog;
  bool readBack;

  void toggleAutoDialog() {
    autoDialog = !autoDialog;
    notifyListeners();
  }

  void toggleReadBack() {
    readBack = !readBack;
    notifyListeners();
  }
}
