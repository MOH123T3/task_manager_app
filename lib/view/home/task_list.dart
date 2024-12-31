import 'package:demo_task_manager/model/task_model.dart';
import 'package:demo_task_manager/services/notification_services.dart';
import 'package:demo_task_manager/utils/app_colors.dart';
import 'package:demo_task_manager/utils/app_styles.dart';
import 'package:demo_task_manager/utils/constant.dart';
import 'package:demo_task_manager/view_model/task_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class TaskListPage extends ConsumerWidget {
  TextEditingController searchController = TextEditingController();

  TaskListPage({super.key});

  DateTime initDate = DateTime.now();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final taskState = ref.watch(taskNotifierProvider);

    return taskState.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      data: (tasks) {
        return ListView.builder(
          itemCount: tasks.length,
          itemBuilder: (context, index) {
            final task = tasks[index];
            pushNotification(initDate, task.reminderTime);
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: ListTile(
                title: Text(
                  task.title,
                  style: Constant.isDark
                      ? AppStyles.darkThemeTextStyle(18, AppColors.blackColor)
                      : AppStyles.lightThemeTextStyle(18, AppColors.whiteColor),
                ),
                subtitle: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Divider(),
                    Text(
                      task.description,
                      style: Constant.isDark
                          ? AppStyles.darkThemeTextStyle(
                              13, AppColors.blackColor)
                          : AppStyles.lightThemeTextStyle(
                              13, AppColors.whiteColor),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                            "${task.reminderTime.day}/${task.reminderTime.month}/ ${task.reminderTime.year}",
                            style: Constant.isDark
                                ? AppStyles.darkThemeTextStyle(
                                    13, AppColors.blackColor)
                                : AppStyles.lightThemeTextStyle(
                                    13, AppColors.whiteColor)),
                        const SizedBox(
                          width: 15,
                        ),
                        Container(
                          height: 30,
                          margin: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Constant.isDark
                                ? AppColors.blackColor
                                : AppColors.lightBlueColor,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Row(
                            children: [
                              IconButton(
                                  onPressed: () {
                                    _showEditTaskDialog(context, ref, task);
                                  },
                                  icon: const Icon(
                                    Icons.edit,
                                    size: AppStyles.isMobileScreenIcon,
                                  )),
                              IconButton(
                                  onPressed: () {
                                    ref
                                        .read(taskNotifierProvider.notifier)
                                        .deleteTask(task.id!);
                                  },
                                  icon: const Icon(
                                    Icons.delete,
                                    size: AppStyles.isMobileScreenIcon,
                                  ))
                            ],
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
      error: (error, stack) => Center(child: Text('Error: $error')),
    );
  }

  Future pushNotification(DateTime initDate, DateTime date) {
    print("dates -- ${initDate} \n ${date}");

    String dateInit = DateFormat.yMEd().add_jms().format(initDate);
    String dates = DateFormat.yMEd().add_jms().format(date);

    print(dateInit);
    print(dates);

    return Future.delayed(const Duration(seconds: 20)).then((s) {
      NotificationService().showNotification(
        id: 1,
        body: "Welcome",
        payload: "now",
        title: "New Notification",
      );
    });
  }

  void _showEditTaskDialog(BuildContext context, WidgetRef ref, Task task) {
    final titleController = TextEditingController(text: task.title);
    final descriptionController = TextEditingController(text: task.description);
    DateTime reminderTime = task.reminderTime;
    String category = task.category;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Task'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Title')),
            TextField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: 'Description')),
            TextField(
              controller: TextEditingController(
                  text:
                      "${reminderTime.day}/ ${reminderTime.month}/ ${reminderTime.year}"),
              decoration: const InputDecoration(labelText: 'Reminder Time'),
              onTap: () async {
                DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: reminderTime,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101),
                );
                if (picked != null && picked != reminderTime) {
                  reminderTime = picked;
                }
              },
            ),
            DropdownButton<String>(
              value: category,
              onChanged: (value) {
                category = value!;
              },
              items: ['General', 'Work', 'Personal', 'Urgent']
                  .map((e) => DropdownMenuItem<String>(
                        value: e,
                        child: Text(e),
                      ))
                  .toList(),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              final updatedTask = Task(
                id: task.id,
                title: titleController.text,
                description: descriptionController.text,
                reminderTime: reminderTime,
                category: category,
              );
              ref.read(taskNotifierProvider.notifier).updateTask(updatedTask);

              Navigator.pop(context);
            },
            child: const Text('Update Task'),
          ),
        ],
      ),
    );
  }
}
