import 'package:demo_task_manager/utils/app_colors.dart';
import 'package:demo_task_manager/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class DrawerScreen extends StatelessWidget {
  const DrawerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: Hive.box('theme').listenable(),
        builder: (context, box, child) {
          final isDark = box.get('isDark', defaultValue: false);
          Constant.isDark = isDark;
          return Drawer(
              backgroundColor:
                  isDark ? AppColors.whiteColor : AppColors.blackColor,
              child: ListView(padding: EdgeInsets.zero, children: [
                DrawerHeader(
                  child: Text(
                    'Change Theme',
                    style: TextStyle(
                        color: isDark
                            ? AppColors.blueColor
                            : AppColors.whiteColor),
                  ),
                ),
                SizedBox(
                  height: 50,
                  child: Switch(
                      value: isDark,
                      onChanged: (val) {
                        box.put('isDark', val);
                      }),
                )
              ]));
        });
  }
}
