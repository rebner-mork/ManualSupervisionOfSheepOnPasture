import 'dart:async';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

void scrollToKey(ScrollController scrollController, GlobalKey key,
    {bool hasAppbar = false}) {
  // https://stackoverflow.com/questions/54291245/get-y-position-of-container-on-flutter
  RenderBox box = key.currentContext!.findRenderObject() as RenderBox;
  Offset position = box.localToGlobal(Offset.zero);
  double y = position.dy;

  y -= hasAppbar ? AppBar().preferredSize.height : 0;

  Timer(const Duration(milliseconds: 50), () {
    scrollController.animateTo(scrollController.position.pixels + y - 80,
        duration: const Duration(milliseconds: 500), curve: Curves.ease);
  });
}

Map<String, int> gatherRegisteredData(
    Map<String, TextEditingController> textControllers) {
  final Map<String, int> data = {};

  textControllers.forEach((String key, TextEditingController controller) {
    data[key] = controller.text.isEmpty ? 0 : int.parse(controller.text);
  });

  return data;
}

// https://stackoverflow.com/questions/52659759/how-can-i-get-the-size-of-the-text-widget-in-flutter
Size textSize(String text, TextStyle style) {
  final TextPainter textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      maxLines: 1,
      textDirection: TextDirection.ltr)
    ..layout(minWidth: 0, maxWidth: double.infinity);
  return textPainter.size;
}

Map<String, Object> getMetaRegistrationData(
    {required String type,
    required LatLng devicePosition,
    required LatLng registrationPosition}) {
  return {
    'type': type,
    'timestamp': DateTime.now(),
    'devicePosition': {
      'latitude': devicePosition.latitude,
      'longitude': devicePosition.longitude
    },
    'registrationPosition': {
      'latitude': registrationPosition.latitude,
      'longitude': registrationPosition.longitude
    },
  };
}

Future<bool> isConnectedToInternet() async {
  try {
    await http.get(Uri.parse("https://www.google.com"));
    return true;
  } catch (_) {
    return false;
  }
}
