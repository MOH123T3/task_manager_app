import 'package:task_manager/utils/app_colors.dart';
import 'package:flutter/material.dart';

//Todo Theme data for application
ThemeData getAppTheme(BuildContext context, bool isDarkTheme) {
  return ThemeData(
    scaffoldBackgroundColor:
        isDarkTheme ? AppColors.darkBackground : AppColors.lightBackground,
    cardTheme: CardTheme(
        color: isDarkTheme
            ? AppColors.lightCardBackground
            : AppColors.darkCardBackground),
    switchTheme: SwitchThemeData(
      thumbColor:
          WidgetStateProperty.all(isDarkTheme ? Colors.white : Colors.black),
    ),
    listTileTheme:
        ListTileThemeData(iconColor: isDarkTheme ? Colors.white : Colors.black),
    appBarTheme: AppBarTheme(
        backgroundColor: isDarkTheme ? Colors.black : Colors.white,
        iconTheme: IconThemeData(
            color: isDarkTheme
                ? AppColors.lightAccentColor
                : AppColors.darkAccentColor)),
  );
}
