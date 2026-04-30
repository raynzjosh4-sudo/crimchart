import 'package:flutter/material.dart';

class CardColors {
  static const List<Color> palette = [
    Colors.purpleAccent,
    Colors.cyanAccent,
    Colors.greenAccent,
    Colors.orangeAccent,
    Colors.pinkAccent,
    Colors.yellowAccent,
    Colors.indigoAccent,
  ];

  static Color getColor(int index) {
    return palette[index % palette.length];
  }
}





























