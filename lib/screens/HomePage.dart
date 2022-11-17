import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutterai/main.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isWorking = false;
  String result = "";
  late CameraController cameraController;
  late CameraImage imgCamera;

  initCamera() {
    cameraController = CameraController(cameras[0], ResolutionPreset.high);
    cameraController.initialize().then((value) {
      if (!mounted) {
        return;
      }
      setState(() {
        cameraController.startImageStream(
          (imageFromStream) {
            if (!isWorking) {
              isWorking = true;
              imgCamera = imageFromStream;
            }
          },
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: imgCamera == null
            ? Center()
            : AspectRatio(
                aspectRatio: cameraController.value.aspectRatio,
                child: CameraPreview(cameraController),
              ),
      ),
    );
  }
}
