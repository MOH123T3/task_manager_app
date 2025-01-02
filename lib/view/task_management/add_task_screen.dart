// ignore_for_file: library_private_types_in_public_api

import 'dart:async';

import 'package:task_manager/model/task_model.dart';
import 'package:task_manager/services/notification_services.dart';
import 'package:task_manager/utils/app_colors.dart';
import 'package:task_manager/utils/app_strings.dart';
import 'package:task_manager/utils/app_styles.dart';
import 'package:task_manager/utils/constant.dart';
import 'package:task_manager/utils/responsive.dart';
import 'package:task_manager/utils/widget.dart';
import 'package:task_manager/view_model/task_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  @override
  final _formKey = GlobalKey<FormState>();
  String? _category;
  DateTime? reminderDateTime;
  DateTime reminderDate = DateTime.now();
  TimeOfDay reminderTime = const TimeOfDay(hour: 00, minute: 00);
  String? status;
  final List<String> _categories = ['General', 'Work', 'Personal', 'Urgent'];
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  String title = "";
  late Timer timer;
  DateTime targetTime =
      DateTime(2025, 1, 2, 15, 30, 00); // Specify the target time (e.g., 15:30)

  void initState() {
    super.initState();

    timer = Timer.periodic(Duration(minutes: 1), (Timer t) {
      _checkTime();
    });
  }

  @override
  void dispose() {
    timer.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //Todo Alert Dialog for Adding tasks
    return AlertDialog(
      backgroundColor: Constant.isDark
          ? AppColors.darkDialogBackground
          : AppColors.lightDialogBackground,
      title: Text(
        AppStrings.addTask,
        style: AppStyles.isTabletTextStyle(
            Constant.isDark ? AppColors.whiteColor : AppColors.blackColor),
      ),
      content: SingleChildScrollView(
        child: Consumer(builder: (context, WidgetRef ref, child) {
          return Form(
              key: _formKey,
              child: Responsive(
                  //Todo for mobile screen
                  mobile: mobileView(ref),
                  //Todo for tablet screen
                  tablet: tabletView(ref)));
        }),
      ),
    );
  }

//Todo Date time picker for reminder date
  Future pickDateAndTime() async {
    DateTime? date = await pickDate();
    if (date == null) return;

    TimeOfDay? time = await pickTime();
    if (time == null) return;

    final dateTime =
        DateTime(date.year, date.month, date.day, time.hour, time.minute);
    if (dateTime != reminderDateTime) {
      setState(() {
        reminderDateTime = dateTime;
      });
    }
  }

//Todo Time picker
  pickTime() async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime:
          TimeOfDay(hour: DateTime.now().hour, minute: DateTime.now().minute),
    );
    if (pickedTime != null && pickedTime != reminderTime) {
      setState(() {
        reminderTime = pickedTime;
      });
    }

    return pickedTime;
  }

//Todo Date picker
  pickDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null && pickedDate != reminderDate) {
      setState(() {
        reminderDate = pickedDate;
      });
    }

    return pickedDate;
  }

//Todo  category method
  selectCategory() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[400]!),
      ),
      child: DropdownButtonFormField<String>(
        value: _category,
        decoration: const InputDecoration(
          border: InputBorder.none,
        ),
        isExpanded: true,
        items: _categories.map((String category) {
          return DropdownMenuItem<String>(
            value: category,
            child: Text(category),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            _category = value;
          });
        },
        validator: (value) => value == null ? 'Please select a category' : null,
      ),
    );
  }

// Todo save button where task submited
  saveButton(ref) {
    return SizedBox(
        width: double.infinity,
        child: CustomWidget.customButton(AppStrings.save, () {
          //Todo Get Notification on Submitted task
          // Update the target time
          setState(() {
            targetTime = DateTime(
                reminderDateTime!.year,
                reminderDateTime!.month,
                reminderDateTime!.day,
                reminderDateTime!.hour,
                reminderDateTime!.minute,
                reminderDateTime!.second,
                reminderDateTime!.millisecond,
                reminderDateTime!.microsecond);
          });
          if (_formKey.currentState!.validate()) {
            final task = Task(
                title: titleController.text,
                description: descriptionController.text,
                reminderTime: reminderDateTime ?? DateTime.now(),
                category: _category ?? "",
                //Todo by default status was pending
                status: status ?? "Pending");
            title = titleController.text;
            ref.read(taskNotifierProvider.notifier).addTask(task);
            getNotification(title, "Your Task is Submitted");
            Navigator.pop(context);
          }
        }));
  }

// Todo responsive mobile view screen method
  Widget mobileView(WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 16),
        Text(AppStrings.checkStatus,
            style: AppStyles.isMobileTextStyle(
                Constant.isDark ? AppColors.whiteColor : AppColors.blackColor)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[400]!),
          ),
          child: DropdownButtonFormField<String>(
            decoration: const InputDecoration(
              border: InputBorder.none,
            ),
            value: status,
            onChanged: (value) {
              setState(() {
                status = value;
              });
            },
            items: ['Pending', 'Completed']
                .map((e) => DropdownMenuItem<String>(
                      value: e,
                      onTap: () {
                        setState(() {
                          status = e;
                        });
                      },
                      child: Text(e),
                    ))
                .toList(),
          ),
        ),
        const SizedBox(height: 16),
        Text(AppStrings.selectCategory,
            style: AppStyles.isMobileTextStyle(
                Constant.isDark ? AppColors.whiteColor : AppColors.blackColor)),
        const SizedBox(height: 8),
        selectCategory(),
        const SizedBox(height: 16),
        Text(AppStrings.taskTitle,
            style: AppStyles.isMobileTextStyle(
                Constant.isDark ? AppColors.whiteColor : AppColors.blackColor)),
        const SizedBox(height: 8),
        CustomWidget.customTextField(
            titleController, AppStrings.pleaseEnterTaskTitle, () {}, false, 1),
        const SizedBox(height: 16),
        Text(
          AppStrings.taskDescription,
          style: AppStyles.isMobileTextStyle(
              Constant.isDark ? AppColors.whiteColor : AppColors.blackColor),
        ),
        const SizedBox(height: 8),
        CustomWidget.customTextField(descriptionController,
            AppStrings.pleaseEnterTaskDescription, () {}, false, 5),
        const SizedBox(height: 16),
        Text(
          AppStrings.reminderTiming,
          style: AppStyles.isMobileTextStyle(
              Constant.isDark ? AppColors.whiteColor : AppColors.blackColor),
        ),
        const SizedBox(height: 8),
        CustomWidget.customTextField(
            TextEditingController(
                text: reminderDateTime != null
                    ? '${reminderDateTime!.year}/${reminderDateTime!.month}/${reminderDateTime!.day} ${reminderDateTime!.hour}:${reminderDateTime!.minute}'
                    : AppStrings.selectReminderDate),
            AppStrings.pleasePickReminderDate, () async {
          pickDateAndTime();
        }, true, 1),
        const SizedBox(height: 20),
        saveButton(ref)
      ],
    );
  }

// Todo responsive tablet view screen method
  Widget tabletView(WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(AppStrings.taskTitle,
                      style: AppStyles.isTabletTextStyle(Constant.isDark
                          ? AppColors.whiteColor
                          : AppColors.blackColor)),
                  const SizedBox(height: 8),
                  CustomWidget.customTextField(titleController,
                      AppStrings.pleaseEnterTaskTitle, () {}, false, 1),
                  const SizedBox(height: 16),
                  Text(
                    AppStrings.taskDescription,
                    style: AppStyles.isTabletTextStyle(Constant.isDark
                        ? AppColors.whiteColor
                        : AppColors.blackColor),
                  ),
                  const SizedBox(height: 8),
                  CustomWidget.customTextField(descriptionController,
                      AppStrings.pleaseEnterTaskDescription, () {}, false, 5),
                ],
              ),
            ),
            const SizedBox(
              width: 15,
            ),
            Expanded(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(AppStrings.selectCategory,
                    style: AppStyles.isTabletTextStyle(Constant.isDark
                        ? AppColors.whiteColor
                        : AppColors.blackColor)),
                const SizedBox(height: 10),
                selectCategory(),
                const SizedBox(height: 20),
                Text(
                  AppStrings.reminderTiming,
                  style: AppStyles.isTabletTextStyle(Constant.isDark
                      ? AppColors.whiteColor
                      : AppColors.blackColor),
                ),
                const SizedBox(height: 8),
                CustomWidget.customTextField(
                    TextEditingController(
                        text: reminderDateTime != null
                            ? '${reminderDateTime!.year}/${reminderDateTime!.month}/${reminderDateTime!.day} ${reminderDateTime!.hour}:${reminderDateTime!.minute}'
                            : AppStrings.selectReminderDate),
                    AppStrings.pleasePickReminderDate, () async {
                  pickDateAndTime();
                }, true, 1),
              ],
            ))
          ],
        ),
        const SizedBox(height: 16),
        Text(AppStrings.checkStatus,
            style: AppStyles.isTabletTextStyle(
                Constant.isDark ? AppColors.whiteColor : AppColors.blackColor)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[400]!),
          ),
          child: DropdownButtonFormField<String>(
            decoration: const InputDecoration(
              border: InputBorder.none,
            ),
            value: status,
            onChanged: (value) {
              setState(() {
                status = value;
              });
            },
            items: ['Pending', 'Completed']
                .map((e) => DropdownMenuItem<String>(
                      value: e,
                      onTap: () {
                        setState(() {
                          status = e;
                        });
                      },
                      child: Text(e),
                    ))
                .toList(),
          ),
        ),
        const SizedBox(height: 20),
        saveButton(ref)
      ],
    );
  }

  void _checkTime() {
    DateTime currentTime = DateTime.now();
    print('currentTime - $currentTime');
    print('targetTime =- ${targetTime}');

    // Compare only the hour and minute
    if (currentTime == targetTime) {
      print("TIme noted");
      getNotification(title, "Your Task Time Completed");
    }
  }

//Todo Get Notification When task Submitted
  Future getNotification(title, body) async {
    return Future.delayed(const Duration(seconds: 1)).then((s) {
      NotificationService().showNotification(
        id: 1,
        body: body,
        payload: "now",
        title: "$title",
      );
    });
  }
}
