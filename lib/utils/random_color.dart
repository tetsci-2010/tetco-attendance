import 'dart:math';
import 'package:flutter/material.dart';

/// Returns a vibrant, deep color with semi-transparent alpha (35-40)
Color randomVibrantColorWithAlpha() {
  final Random random = Random();

  // Pick a vibrant hue range
  final List<Color> vibrantColors = [
    Color.fromARGB(0, 255, 0, 0), // Red
    Color.fromARGB(0, 0, 128, 255), // Blue
    Color.fromARGB(0, 0, 200, 100), // Green
    Color.fromARGB(0, 255, 165, 0), // Orange
    Color.fromARGB(0, 128, 0, 128), // Purple
    Color.fromARGB(0, 255, 0, 255), // Magenta
    Color.fromARGB(0, 0, 255, 255), // Cyan
  ];

  // Pick a random base color
  Color base = vibrantColors[random.nextInt(vibrantColors.length)];

  // Random alpha between 35-40
  int alpha = 35 + random.nextInt(6);

  return base.withAlpha(alpha);
}
