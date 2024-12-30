import 'package:demo_task_manager/routes/name_routes.dart';
import 'package:demo_task_manager/view/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'routes/routes.dart';

void main() {
  runApp(

//Todo Initialize Riverpod state management
      const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      initialRoute: NameRoutes.splashScreen,
      onGenerateRoute: Routes.generateRoute,
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
