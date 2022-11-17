// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutterai/config/ThemeColor.dart';
import 'package:flutterai/screens/HomePage.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color1,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: color1,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HomePage(),
            ),
          );
        },
        label: Text(
          "Let's Try",
          style: TextStyle(
            fontSize: 30,
            color: color3,
          ),
        ),
      ),
    );
  }
}
