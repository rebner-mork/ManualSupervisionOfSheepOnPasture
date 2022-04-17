import 'package:app/widgets/circular_buttons.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

import 'dart:io';
import 'package:path/path.dart' as p;

import 'package:app/utils/constants.dart' as constants;

class CameraPage extends StatefulWidget {
  const CameraPage({Key? key, required this.onPhotoCaptured}) : super(key: key);

  final ValueChanged<dynamic> onPhotoCaptured;

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  late CameraController _cameraController;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();

    _cameraController = CameraController(
      constants.deviceCamera,
      ResolutionPreset.veryHigh,
    );
    _initializeControllerFuture = _cameraController.initialize();
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Stack(children: [
              CameraPreview(_cameraController),
              Positioned(
                  left: 10,
                  top: 10 + MediaQuery.of(context).viewPadding.top,
                  child: CircularButton(
                    child: const Icon(
                      Icons.cancel,
                      size: 42,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ))
            ]);
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton.large(
        onPressed: () async {
          try {
            await _initializeControllerFuture;

            final image = await _cameraController.takePicture();

            Directory(constants.applicationDocumentDirectoryPath + '/cadavers/')
                .createSync(recursive: true);
            File newFile = File(image.path).renameSync(
                constants.applicationDocumentDirectoryPath +
                    '/cadavers/' +
                    p.basename(image.path));

            widget.onPhotoCaptured(newFile.path);

            Navigator.pop(context);
          } catch (e) {
            debugPrint(e.toString());
          }
        },
        child: const Icon(
          Icons.camera_alt,
          size: 60,
          color: Colors.black,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
