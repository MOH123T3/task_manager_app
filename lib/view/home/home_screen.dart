import 'package:demo_task_manager/model/task_model.dart';
import 'package:demo_task_manager/services/notification_services.dart';
import 'package:demo_task_manager/utils/app_colors.dart';
import 'package:demo_task_manager/utils/app_strings.dart';
import 'package:demo_task_manager/utils/app_styles.dart';
import 'package:demo_task_manager/utils/responsive.dart';
import 'package:demo_task_manager/view/home/add_task_screen.dart';
import 'package:demo_task_manager/view/home/drawer_screen.dart';
import 'package:demo_task_manager/view/home/edit_task.dart';
import 'package:demo_task_manager/view/home/task_list.dart';
import 'package:demo_task_manager/view_model/task_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: AppColors.lightBlue,
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
      ),

      body: TaskListPage(),
      floatingActionButton: floatingButton(context),
      drawer: const DrawerScreen(),
    );
  }

  card() {
    return Container(
      padding: const EdgeInsets.all(15),
      margin: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(9),
        // color: AppColors.whiteColor
      ),
      child: const Column(
        children: [
          Row(
            children: [Icon(Icons.task), Text("data")],
          ),
          SizedBox(
            height: 20,
          ),
          Text("This is task for demo"),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text("Date"), Icon(Icons.date_range)],
          )
        ],
      ),
    );
  }

  floatingButton(context) {
    return FloatingActionButton.extended(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return const AddTaskScreen();
            },
          );
        },
        label: const Text(
          AppStrings.addTask,
          style: AppStyles.leadingTextStyle,
        ),
        icon: const Icon(
          Icons.add_task,
          size: 18,
        ));
  }
}
