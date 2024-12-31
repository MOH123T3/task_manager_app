import 'package:demo_task_manager/routes/name_routes.dart';
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
    return const Scaffold(
      body: Center(
        child: Icon(
          Icons.task_alt_outlined,
          size: 50,
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
