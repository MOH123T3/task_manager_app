import 'package:task_manager/model/task_model.dart';
import 'package:task_manager/utils/app_colors.dart';
import 'package:task_manager/utils/app_strings.dart';
import 'package:task_manager/utils/app_styles.dart';
import 'package:task_manager/utils/constant.dart';
import 'package:task_manager/utils/responsive.dart';
import 'package:task_manager/utils/widget.dart';
import 'package:task_manager/view_model/task_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void showEditTaskDialog(BuildContext context, WidgetRef ref, Task task) {
  final titleController = TextEditingController(text: task.title);
  final descriptionController = TextEditingController(text: task.description);
  DateTime reminderTime = task.reminderTime;
  String category = task.category;
  String selectedOption = task.status;
  final _formKey = GlobalKey<FormState>();

//Todo AlertDialog for Edit or Update tasks
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
        backgroundColor: Constant.isDark
            ? AppColors.darkDialogBackground
            : AppColors.lightDialogBackground,
        title: Text(
          AppStrings.updateTask,
          style: AppStyles.isTabletTextStyle(
              Constant.isDark ? AppColors.whiteColor : AppColors.blackColor),
        ),
        content: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Responsive(
                  //Todo mobile view

                  mobile: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(AppStrings.updateStatus,
                          style: AppStyles.isMobileTextStyle(Constant.isDark
                              ? AppColors.whiteColor
                              : AppColors.blackColor)),
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
                          value: selectedOption,
                          onChanged: (value) {
                            selectedOption = value!;
                          },
                          items: ['Pending', 'Completed']
                              .map((e) => DropdownMenuItem<String>(
                                    value: e,
                                    child: Text(e),
                                  ))
                              .toList(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(AppStrings.updateCategory,
                          style: AppStyles.isMobileTextStyle(Constant.isDark
                              ? AppColors.whiteColor
                              : AppColors.blackColor)),
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
                          value: category,
                          onChanged: (value) {
                            category = value!;
                          },
                          items: ['General', 'Work', 'Personal', 'Urgent']
                              .map((e) => DropdownMenuItem<String>(
                                    onTap: () {
                                      category = e;
                                    },
                                    value: e,
                                    child: Text(e),
                                  ))
                              .toList(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(AppStrings.updateTaskTitle,
                          style: AppStyles.isMobileTextStyle(Constant.isDark
                              ? AppColors.whiteColor
                              : AppColors.blackColor)),
                      const SizedBox(height: 8),
                      CustomWidget.customTextField(titleController,
                          AppStrings.pleaseEnterTaskTitle, () {}, false, 1),
                      const SizedBox(height: 16),
                      Text(
                        AppStrings.updateTaskDescription,
                        style: AppStyles.isMobileTextStyle(Constant.isDark
                            ? AppColors.whiteColor
                            : AppColors.blackColor),
                      ),
                      const SizedBox(height: 8),
                      CustomWidget.customTextField(
                          descriptionController,
                          AppStrings.pleaseEnterTaskDescription,
                          () {},
                          false,
                          5),
                      const SizedBox(height: 16),
                      Text(
                        AppStrings.updateTaskReminder,
                        style: AppStyles.isMobileTextStyle(Constant.isDark
                            ? AppColors.whiteColor
                            : AppColors.blackColor),
                      ),
                      const SizedBox(height: 8),
                      CustomWidget.customTextField(
                          TextEditingController(
                              // ignore: unnecessary_null_comparison
                              text: reminderTime != null
                                  ? '${reminderTime.year}/${reminderTime.month}/${reminderTime.day} ${reminderTime.hour}:${reminderTime.minute}'
                                  : AppStrings.selectReminderDate),
                          AppStrings.pleasePickReminderDate, () async {
                        DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: reminderTime,
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2101),
                        );
                        if (picked != null && picked != reminderTime) {
                          reminderTime = picked;
                        }
                      }, true, 1),
                    ],
                  ),
                  //Todo tablet view
                  tablet: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                              child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(AppStrings.updateTaskTitle,
                                  style: AppStyles.isTabletTextStyle(
                                      Constant.isDark
                                          ? AppColors.whiteColor
                                          : AppColors.blackColor)),
                              const SizedBox(height: 8),
                              CustomWidget.customTextField(
                                  titleController,
                                  AppStrings.pleaseEnterTaskTitle,
                                  () {},
                                  false,
                                  1),
                              const SizedBox(height: 16),
                              Text(
                                AppStrings.updateTaskDescription,
                                style: AppStyles.isTabletTextStyle(
                                    Constant.isDark
                                        ? AppColors.whiteColor
                                        : AppColors.blackColor),
                              ),
                              const SizedBox(height: 8),
                              CustomWidget.customTextField(
                                  descriptionController,
                                  AppStrings.pleaseEnterTaskDescription,
                                  () {},
                                  false,
                                  5),
                            ],
                          )),
                          const SizedBox(
                            width: 15,
                          ),
                          Expanded(
                              child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(AppStrings.updateCategory,
                                  style: AppStyles.isTabletTextStyle(
                                      Constant.isDark
                                          ? AppColors.whiteColor
                                          : AppColors.blackColor)),
                              const SizedBox(height: 10),
                              Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 12),
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Colors.grey[400]!),
                                ),
                                child: DropdownButtonFormField<String>(
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                  ),
                                  value: category,
                                  onChanged: (value) {
                                    category = value!;
                                  },
                                  items:
                                      ['General', 'Work', 'Personal', 'Urgent']
                                          .map((e) => DropdownMenuItem<String>(
                                                onTap: () {
                                                  category = e;
                                                },
                                                value: e,
                                                child: Text(e),
                                              ))
                                          .toList(),
                                ),
                              ),
                              const SizedBox(height: 20),
                              Text(AppStrings.updateTaskReminder,
                                  style: AppStyles.isTabletTextStyle(
                                      Constant.isDark
                                          ? AppColors.whiteColor
                                          : AppColors.blackColor)),
                              const SizedBox(height: 8),
                              CustomWidget.customTextField(
                                  TextEditingController(
                                      // ignore: unnecessary_null_comparison
                                      text: reminderTime != null
                                          ? '${reminderTime.year}/${reminderTime.month}/${reminderTime.day} ${reminderTime.hour}:${reminderTime.minute}'
                                          : AppStrings.selectReminderDate),
                                  AppStrings.pleasePickReminderDate, () async {
                                DateTime? picked = await showDatePicker(
                                  context: context,
                                  initialDate: reminderTime,
                                  firstDate: DateTime(2000),
                                  lastDate: DateTime(2101),
                                );
                                if (picked != null && picked != reminderTime) {
                                  reminderTime = picked;
                                }
                              }, true, 1),
                            ],
                          ))
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(AppStrings.updateStatus,
                          style: AppStyles.isTabletTextStyle(Constant.isDark
                              ? AppColors.whiteColor
                              : AppColors.blackColor)),
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
                          value: selectedOption,
                          onChanged: (value) {
                            selectedOption = value!;
                          },
                          items: ['Pending', 'Completed']
                              .map((e) => DropdownMenuItem<String>(
                                    value: e,
                                    child: Text(e),
                                  ))
                              .toList(),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                CustomWidget.customButton(AppStrings.updateTask, () {
                  if (_formKey.currentState!.validate()) {
                    //Todo Update task

                    final updatedTask = Task(
                      status: selectedOption,
                      id: task.id,
                      title: titleController.text,
                      description: descriptionController.text,
                      reminderTime: reminderTime,
                      category: category,
                    );
                    ref
                        .read(taskNotifierProvider.notifier)
                        .updateTask(updatedTask);

                    Navigator.pop(context);
                  }
                }),
              ],
            ),
          ),
        )),
  );
}
