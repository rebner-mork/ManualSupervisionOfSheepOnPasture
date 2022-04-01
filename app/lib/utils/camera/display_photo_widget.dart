import 'dart:io';

import 'package:flutter/material.dart';

import 'package:app/widgets/circular_buttons.dart';

class DisplayPhotoWidget extends StatelessWidget {
  const DisplayPhotoWidget(
      {Key? key, required this.imagePath, this.onDeletePhoto})
      : super(key: key);

  final String imagePath;

  final VoidCallback? onDeletePhoto;

  final double buttonHeight = 50;
  final double buttonWidth = 50;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bilde av kadaver')),
      body: Stack(children: [
        SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Image.file(File(imagePath))),
        Positioned(
            left: 100,
            bottom: 10 + MediaQuery.of(context).viewPadding.bottom,
            child: CircularButton(
              height: buttonHeight,
              width: buttonWidth,
              child: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            )),
        Positioned(
            left: MediaQuery.of(context).size.width / 2 - 25,
            bottom: 10 + MediaQuery.of(context).viewPadding.bottom,
            child: CircularButton(
                height: buttonHeight,
                width: buttonWidth,
                child: const Icon(Icons.delete),
                onPressed: () {
                  if (onDeletePhoto != null) {
                    onDeletePhoto!();
                  }
                  Navigator.pop(context);
                })),
        Positioned(
            right: 100,
            bottom: 10 + MediaQuery.of(context).viewPadding.bottom,
            child: CircularButton(
                height: buttonHeight,
                width: buttonWidth,
                child: const Icon(Icons.camera_alt),
                onPressed: () => debugPrint('Not implemented')))
      ]),
    );
  }
}
