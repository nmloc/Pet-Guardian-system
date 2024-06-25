import 'package:flutter/material.dart';

class AppSizes {
  static double screenWidth = 0.0;
  static double screenHeight = 0.0;
  static Orientation? orientation;

  void init(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    orientation = MediaQuery.of(context).orientation;
  }
}

// Get the proportionate height as per screen size
double proportionateHeight(double inputHeight) =>
    (inputHeight / 812.0) * AppSizes.screenHeight;

// Get the proportionate height as per screen size
double proportionateWidth(double inputWidth) =>
    (inputWidth / 375.0) * AppSizes.screenWidth;
