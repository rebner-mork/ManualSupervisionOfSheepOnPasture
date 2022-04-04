import 'package:app/widgets/circular_buttons.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

import 'package:app/utils/constants.dart' as constants;

class CameraPage extends StatefulWidget {
  CameraPage({Key? key, required this.onPhotoCaptured}) : super(key: key);

  late ValueChanged<dynamic> onPhotoCaptured;

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
            /*final size = MediaQuery.of(context).size;
            final deviceRatio = size.width / size.height;
            final xScale = _cameraController.value.aspectRatio / deviceRatio;*/
            return Stack(children: [
              /*
              AspectRatio(
                aspectRatio: deviceRatio,
                child: Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.diagonal3Values(xScale, 1, 1),
                  child: CameraPreview(_cameraController),
                ),
              ),
              */
              CameraPreview(_cameraController),
              Positioned(
                  left: 10,
                  top: 10 + MediaQuery.of(context).viewPadding.top,
                  child: CircularButton(
                    child: const Icon(Icons.cancel),
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

            widget.onPhotoCaptured(image.path);

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
