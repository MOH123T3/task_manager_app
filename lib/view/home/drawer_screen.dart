import 'package:task_manager/utils/app_colors.dart';
import 'package:task_manager/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class DrawerScreen extends StatelessWidget {
  const DrawerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    //Todo Get Application theme bool
    return ValueListenableBuilder(
        valueListenable: Hive.box('theme').listenable(),
        builder: (context, box, child) {
          final isDark = box.get('isDark', defaultValue: false);
          Constant.isDark = isDark;
          return Drawer(
              backgroundColor: isDark ? Colors.black : Colors.white,
              child: ListView(padding: EdgeInsets.zero, children: [
                DrawerHeader(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        'Change Theme',
                        style: TextStyle(
                            color: isDark
                                ? AppColors.whiteColor
                                : AppColors.blackColor),
                      ),
                      SizedBox(
                        height: 50,
                        child: Switch(
                            value: isDark,
                            onChanged: (val) {
                              box.put('isDark', val);
                            }),
                      )
                    ],
                  ),
                ),
              ]));
        });
  }
}
