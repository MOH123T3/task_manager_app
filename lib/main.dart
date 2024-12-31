import 'package:demo_task_manager/routes/name_routes.dart';
import 'package:demo_task_manager/services/notification_services.dart';
import 'package:demo_task_manager/utils/app_theme.dart';
import 'package:demo_task_manager/utils/constant.dart';
import 'package:demo_task_manager/view/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'routes/routes.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

Future<void> main() async {
  //Todo Notification services initialization
  WidgetsFlutterBinding.ensureInitialized();

  //Todo Permission handle for Notification

  await Permission.notification.isDenied.then((value) {
    if (value) {
      Permission.notification.request();
    }
  });
  final NotificationService notificationService = NotificationService();
  await notificationService.initNotification();
  await Hive.initFlutter();

//Todo Store box name
  await Hive.openBox('theme');

//Todo Initialize Riverpod state management
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: Hive.box('theme').listenable(),
        builder: (context, box, child) {
          final isDark = box.get('isDark', defaultValue: false);
          Constant.isDark = isDark;
          return MaterialApp(
            theme: getAppTheme(context, isDark),
            initialRoute: NameRoutes.splashScreen,
            onGenerateRoute: Routes.generateRoute,
            debugShowCheckedModeBanner: false,
            home: const SplashScreen(),
          );
        });
  }
}
