import 'package:flutter/material.dart';

ThemeData getAppTheme(BuildContext context, bool isDarkTheme) {
  return ThemeData(
    scaffoldBackgroundColor: isDarkTheme ? Colors.black : Colors.white,
    // textTheme: isDarkTheme
    //     ? Typography(platform: TargetPlatform.android).white
    //     : Typography(platform: TargetPlatform.android).black,
    cardTheme: CardTheme(color: isDarkTheme ? Colors.white : Colors.black54),
    switchTheme: SwitchThemeData(
      thumbColor:
          WidgetStateProperty.all(isDarkTheme ? Colors.white : Colors.black),
    ),
    listTileTheme:
        ListTileThemeData(iconColor: isDarkTheme ? Colors.white : Colors.black),
    appBarTheme: AppBarTheme(
        backgroundColor: isDarkTheme ? Colors.black : Colors.white,
        iconTheme:
            IconThemeData(color: isDarkTheme ? Colors.white : Colors.black54)),
  );
}
