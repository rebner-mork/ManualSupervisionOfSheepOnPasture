import 'dart:async';

import 'package:flutter/material.dart';

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

Map gatherRegisteredData(Map<String, TextEditingController> textControllers) {
  final Map data = <String, int>{};

  textControllers.forEach((String key, TextEditingController controller) {
    data[key] = controller.text.isEmpty ? 0 : int.parse(controller.text);
  });

  return data;
}
