import 'package:flutter/material.dart';

class SettingsProvider extends ChangeNotifier {
  SettingsProvider({this.autoDialog = true});

  bool autoDialog;

  void toggleAutoDialog() {
    autoDialog = !autoDialog;
    notifyListeners();
  }
}

// Provider.of<SettingsProvider>(context).autoDialog;
// Provider.of<SettingsProvider>(context, listen: false).toggleAutoDialog();
