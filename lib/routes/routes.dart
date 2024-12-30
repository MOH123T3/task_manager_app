import 'package:demo_task_manager/routes/name_routes.dart';
import 'package:demo_task_manager/utils/app_strings.dart';
import 'package:demo_task_manager/view/home/home_screen.dart';
import 'package:demo_task_manager/view/splash_screen.dart';
import 'package:flutter/material.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case NameRoutes.splashScreen:
        return MaterialPageRoute(
          builder: (context) => const SplashScreen(),
        );

      case NameRoutes.homeScreen:
        return MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        );

      default:
        return MaterialPageRoute(
            builder: (context) => const Scaffold(
                  body: Center(
                    child: Text(AppStrings.somethingWentWrong),
                  ),
                ));
    }
  }
}