import 'package:task_manager/routes/name_routes.dart';
import 'package:task_manager/utils/app_colors.dart';
import 'package:task_manager/utils/constant.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

//Todo navigate to home page
    navigateHome(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Icon(
          Icons.task_alt_outlined,
          size: 50,
          color: Constant.isDark
              ? AppColors.lightButtonColor
              : AppColors.darkButtonColor,
        ),
      ),
    );
  }

  navigateHome(context) async {
    await Future.delayed(const Duration(seconds: 2)).then((value) {
      Navigator.pushNamed(context, NameRoutes.homeScreen);
    });
  }
}
