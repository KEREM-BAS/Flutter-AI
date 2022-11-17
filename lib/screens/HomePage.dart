// ignore_for_file: file_names

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutterai/config/ThemeColor.dart';
import 'package:flutterai/main.dart';
import 'package:tflite/tflite.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isWorking = false;
  String result = "";
  String asd = "";
  late CameraController cameraController;
  CameraImage? imgCamera;

  loadMode() async {
    await Tflite.loadModel(
      model: "assets/tffile.tflite",
      labels: "assets/tftext.txt",
    );
  }

  @override
  void initState() {
    loadMode();
    cameraController = CameraController(cameras[0], ResolutionPreset.high);
    cameraController.initialize().then((value) {
      if (!mounted) {
        return;
      }
      cameraController.startImageStream(
        (imageFromStream) {
          if (!isWorking) {
            isWorking = true;
            imgCamera = imageFromStream;
            runModelOnStreamFrames();
          }
        },
      );
    });
    super.initState();
  }

  runModelOnStreamFrames() async {
    if (imgCamera != null) {
      var recognitions = await Tflite.runModelOnFrame(
        bytesList: imgCamera!.planes.map((e) {
          return e.bytes;
        }).toList(),
        imageHeight: imgCamera!.height,
        imageWidth: imgCamera!.width,
        numResults: 1,
        threshold: 0.1,
        asynch: true,
        imageMean: 127.5,
        imageStd: 127.5,
        rotation: 90,
      );
      result = "";

      setState(() {
        for (var element in recognitions!) {
          result += element["label"];
        }
        result;
      });
    }
  }

  @override
  void dispose() async {
    super.dispose();
    await Tflite.close();
    cameraController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      asd = result;
    });
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            height: height,
            width: width,
            child: CameraPreview(cameraController),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: FloatingActionButton.extended(
                      backgroundColor: color1,
                      onPressed: () {},
                      label: Text(
                        result,
                        style: TextStyle(color: color3, fontSize: 35),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Center(
            child: Text(
              asd,
              style: TextStyle(color: color4, fontSize: 30),
            ),
          )
        ],
      ),
    );
  }
}
