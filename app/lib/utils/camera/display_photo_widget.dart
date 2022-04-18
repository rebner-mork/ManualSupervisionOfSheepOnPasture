import 'dart:io';
import 'package:flutter/material.dart';
import 'package:app/widgets/circular_buttons.dart';

class DisplayPhotoWidget extends StatelessWidget {
  const DisplayPhotoWidget(
      {Key? key, required this.photoPath, this.onDeletePhoto})
      : super(key: key);

  final String photoPath;

  final VoidCallback? onDeletePhoto;

  @override
  Widget build(BuildContext context) {
    const double buttonHeight = 80;
    const double buttonWidth = 80;

    return Scaffold(
      appBar: AppBar(title: const Text('Bilde av kadaver')),
      body: Stack(children: [
        SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Image.file(File(photoPath))),
        Positioned(
            right: MediaQuery.of(context).size.width / 2 + buttonWidth / 4,
            bottom: MediaQuery.of(context).viewPadding.bottom + 15,
            child: CircularButton(
              height: buttonHeight,
              width: buttonWidth,
              child: const Icon(
                Icons.arrow_back,
                size: buttonHeight - 20,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            )),
        Positioned(
            left: MediaQuery.of(context).size.width / 2 + buttonWidth / 4,
            bottom: MediaQuery.of(context).viewPadding.bottom + 15,
            child: CircularButton(
                height: buttonHeight,
                width: buttonWidth,
                child: const Icon(
                  Icons.delete,
                  size: buttonHeight - 20,
                ),
                onPressed: () {
                  if (onDeletePhoto != null) {
                    onDeletePhoto!();
                  }
                  Navigator.pop(context);
                })),
      ]),
    );
  }
}
