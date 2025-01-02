import 'package:flutter/material.dart';

//Todo global text styles for app

class AppStyles {
  // Todo Text Style for mobile view
  static TextStyle isMobileTextStyle(Color color) {
    return TextStyle(fontSize: 13, fontWeight: FontWeight.w400, color: color);
  }

// Todo Text Style for tablet view
  static TextStyle isTabletTextStyle(Color color) {
    return TextStyle(fontSize: 17, fontWeight: FontWeight.w500, color: color);
  }

  static const double isMobileScreenIcon = 22;
  static const double isTabletScreenIcon = 28;

//Todo Text Style  when application on dark mode
  static darkThemeTextStyle(double fontSize, Color color) {
    return TextStyle(
        fontSize: fontSize, fontWeight: FontWeight.w400, color: color);
  }

//Todo Text Style  when application on light mode
  static lightThemeTextStyle(double fontSize, Color color) {
    return TextStyle(
        fontSize: fontSize, fontWeight: FontWeight.w400, color: color);
  }
}
