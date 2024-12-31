import 'package:demo_task_manager/utils/app_colors.dart';
import 'package:flutter/material.dart';

//Todo global text styles for app

class AppStyles {
  static const TextStyle headingTextStyle =
      TextStyle(fontSize: 20, fontWeight: FontWeight.w500);
  static const TextStyle leadingTextStyle =
      TextStyle(fontSize: 15, fontWeight: FontWeight.w300);

  static const TextStyle subTitleTextStyle =
      TextStyle(fontSize: 14, fontWeight: FontWeight.w400);

  static const TextStyle isMobileTextStyle =
      TextStyle(fontSize: 13, fontWeight: FontWeight.w400);

  static const TextStyle isTabletTextStyle =
      TextStyle(fontSize: 17, fontWeight: FontWeight.w400);

  static const double isMobileScreenIcon = 18;
  static const double isTabletScreenIcon = 23;

  static darkThemeTextStyle(double fontSize, Color color) {
    return TextStyle(
        fontSize: fontSize, fontWeight: FontWeight.w400, color: color);
  }

  static lightThemeTextStyle(double fontSize, Color color) {
    return TextStyle(
        fontSize: fontSize, fontWeight: FontWeight.w400, color: color);
  }
}
