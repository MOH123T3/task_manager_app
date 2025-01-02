import 'package:task_manager/utils/app_colors.dart';
import 'package:task_manager/utils/app_strings.dart';
import 'package:task_manager/utils/constant.dart';
import 'package:task_manager/view/task_management/add_task_screen.dart';
import 'package:task_manager/view/home/drawer_screen.dart';
import 'package:task_manager/view/task_management/task_list_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        actions: [
          InkWell(
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return const AddTaskScreen();
                },
              );
            },
            child: Container(
              margin: EdgeInsets.only(right: 15),
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                  color: Constant.isDark
                      ? AppColors.lightCardBackground
                      : AppColors.darkCardBackground,
                  borderRadius: BorderRadius.circular(9)),
              child: Row(
                children: [
                  Icon(
                    Icons.add_task,
                    size: 18,
                    color: Constant.isDark
                        ? AppColors.lightPrimaryText
                        : AppColors.darkPrimaryText,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(AppStrings.addTask,
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w300,
                          color: Constant.isDark
                              ? AppColors.lightPrimaryText
                              : AppColors.darkPrimaryText)),
                ],
              ),
            ),
          )
        ],
      ),
      body: TaskListPage(),
      drawer: const DrawerScreen(),
    );
  }
}
