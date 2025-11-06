import 'package:flutter/material.dart';

class Utils {
  Color? static colorFromHex(String? hexColor) {
    if (hexColor == null || hexColor.isEmpty) return null;

    String colorString = hexColor.toUpperCase().replaceAll("#", "");
    if (colorString.length == 6) {
      colorString = "FF$colorString"; // aggiunge alpha pieno se manca
    }
    return Color(int.parse(colorString, radix: 16));
  }
}