import 'package:app/utils/camera/display_photo_widget.dart';
import 'package:flutter/material.dart';
import 'dart:io';

import 'camera_widget.dart';

class CameraInputButton extends StatefulWidget {
  CameraInputButton({Key? key, this.size = const Size(80, 120)})
      : super(key: key);

  Size size;

  late String photo = "";

  void pictureTaken() {}

  @override
  State<CameraInputButton> createState() => _CameraInputButtonState();
}

class _CameraInputButtonState extends State<CameraInputButton> {
  @override
  Widget build(BuildContext context) {
    return widget.photo == ""
        ? ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CameraPage(
                          onPhotoCaptured: (photoPath) {
                            setState(() {
                              widget.photo = photoPath;
                            });
                          },
                        )),
              );
            },
            child: const Icon(
              Icons.camera_alt,
              color: Colors.black,
            ),
            style: ElevatedButton.styleFrom(fixedSize: widget.size),
          )
        : GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => DisplayPhotoWidget(
                        imagePath: widget.photo,
                        onDeletePhoto: () {
                          setState(() {
                            widget.photo = "";
                          });
                        },
                      )));
            },
            child: Container(
              height: widget.size.height,
              width: widget.size.width,
              foregroundDecoration: BoxDecoration(
                  image: DecorationImage(
                image: FileImage(File(widget.photo)),
                fit: BoxFit.fill,
              )),
            ));
  }
}
