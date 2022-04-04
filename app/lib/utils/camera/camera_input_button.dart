import 'package:app/utils/camera/display_photo_widget.dart';
import 'package:flutter/material.dart';
import 'dart:io';

import 'camera_widget.dart';

class CameraInputButton extends StatefulWidget {
  const CameraInputButton({Key? key, this.size = const Size(80, 120)})
      : super(key: key);

  final Size size;

  @override
  State<CameraInputButton> createState() => _CameraInputButtonState();
}

class _CameraInputButtonState extends State<CameraInputButton> {
  String photo = "";

  @override
  Widget build(BuildContext context) {
    return photo == ""
        ? ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CameraPage(
                          onPhotoCaptured: (photoPath) {
                            setState(() {
                              photo = photoPath;
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
                        imagePath: photo,
                        onDeletePhoto: () {
                          setState(() {
                            photo = "";
                          });
                        },
                      )));
            },
            child: Container(
              height: widget.size.height,
              width: widget.size.width,
              foregroundDecoration: BoxDecoration(
                  image: DecorationImage(
                image: FileImage(File(photo)),
                fit: BoxFit.fill,
              )),
            ));
  }
}
