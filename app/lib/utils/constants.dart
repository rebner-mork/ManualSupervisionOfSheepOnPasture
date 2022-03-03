import 'dart:io';

import 'package:path_provider/path_provider.dart';

abstract class OfflineZoomLevels {
  static double min = 16;
  static double max = 17;
}

// ignore: non_constant_identifier_names
late final String APPLICATION_DOCUMENT_DIRECTORY_PATH;

Future<void> setConstants() async {
  Directory dir = await getApplicationDocumentsDirectory();
  APPLICATION_DOCUMENT_DIRECTORY_PATH = dir.path;
}
