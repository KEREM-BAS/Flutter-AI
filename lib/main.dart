// ignore_for_file: unused_element

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutterai/screens/HomePage.dart';
import 'package:flutterai/screens/SplashScreen.dart';

List<CameraDescription> cameras = [];

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter AI',
      home: HomePage(),
    );
  }
}



//https://www.google.com.tr/search?q=dog