import 'dart:math';

import 'package:flutter/material.dart';

class AppStyle {
  static final AppStyle _singleton = AppStyle._internal();

  factory AppStyle() {
    return _singleton;
  }

  AppStyle._internal();

  Color getRandomRedColor() {
    Random random = Random();

    int index = random.nextInt(redVariations.length);
    return redVariations[index];
  }

  Color getActiveColor({required DateTime date}) {
    if (date.isBefore(DateTime.now())) {
      return const Color(0xFF92C3B1);
    } else {
      return Colors.grey[350]!;
    }
  }

  List<Color> redVariations = [
    const Color(0xFFCD5C5C),
    const Color(0xFFBC544B),
    const Color(0xFFF88379),
    const Color(0xFFFF6961),
    const Color(0xFFB92E34),
    const Color(0xFFAB4D50),
    const Color(0xFFCE2029),
  ];
}
