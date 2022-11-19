// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors_in_immutables, library_private_types_in_public_api, file_names, unused_local_variable

import 'package:animated_background/animated_background.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutterai/config/ThemeColor.dart';
import 'package:tflite/tflite.dart';
import 'dart:math' as math;

import 'camera.dart';
import 'bndbox.dart';
import 'models.dart';

class HomePage extends StatefulWidget {
  final List<CameraDescription> cameras;

  HomePage(this.cameras);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  List<dynamic>? _recognitions;
  int _imageHeight = 0;
  int _imageWidth = 0;
  String _model = "";

  @override
  void initState() {
    super.initState();
  }

  loadModel() async {
    String? res;
    switch (_model) {
      default:
        res = await Tflite.loadModel(
          model: "assets/yolov2_tiny.tflite",
          labels: "assets/yolov2_tiny.txt",
        );
        break;
    }
    print(res);
  }

  onSelect(model) {
    setState(() {
      _model = model;
    });
    loadModel();
  }

  setRecognitions(recognitions, imageHeight, imageWidth) {
    setState(() {
      _recognitions = recognitions;
      _imageHeight = imageHeight;
      _imageWidth = imageWidth;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size screen = MediaQuery.of(context).size;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: color1,
      body: _model == ""
          ? AnimatedBackground(
              vsync: this,
              behaviour: RandomParticleBehaviour(
                options: ParticleOptions(
                  baseColor: color2,
                  spawnMinSpeed: 10,
                  spawnMaxSpeed: 50,
                ),
              ),
              child: Stack(
                children: [
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(bottom: 25),
                          child: FloatingActionButton.extended(
                            backgroundColor: color2,
                            label: Text(
                              "Let's Try",
                              style: TextStyle(color: color3, fontSize: 30),
                            ),
                            onPressed: () => onSelect(yolo),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: height / 8),
                            child: Text(
                              "Flutter AI",
                              style: TextStyle(color: color3, fontSize: 50),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            )
          : Stack(
              children: [
                Camera(
                  widget.cameras,
                  _model,
                  setRecognitions,
                ),
                BndBox(
                    _recognitions ?? [],
                    math.max(_imageHeight, _imageWidth),
                    math.min(_imageHeight, _imageWidth),
                    screen.height,
                    screen.width,
                    _model),
              ],
            ),
    );
  }
}
