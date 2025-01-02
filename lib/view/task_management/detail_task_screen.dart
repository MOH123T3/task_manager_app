import 'package:flutter/material.dart';
import 'package:task_manager/model/task_model.dart';
import 'package:task_manager/utils/app_colors.dart';
import 'package:task_manager/utils/app_strings.dart';
import 'package:task_manager/utils/app_styles.dart';
import 'package:task_manager/utils/constant.dart';

void showDetailsTaskDialog(BuildContext context, Task task) {
//Todo AlertDialog for Edit or Update tasks
  showDialog(
      context: context,
      builder: (context) => AlertDialog(
            backgroundColor: Constant.isDark
                ? AppColors.darkDialogBackground
                : AppColors.lightDialogBackground,
            title: Text(
              "Task Details",
              style: AppStyles.isMobileTextStyle(Constant.isDark
                  ? AppColors.whiteColor
                  : AppColors.blackColor),
            ),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  Divider(),
                  details(AppStrings.title + " :", task.title),
                  details(AppStrings.description + " :", task.description),
                  details("Date" + " :",
                      "${task.reminderTime.year}/${task.reminderTime.month}/${task.reminderTime.day}"),
                  details("Time" + " :",
                      "${task.reminderTime.hour}: ${task.reminderTime.minute}"),
                  details(AppStrings.status + " :", task.status),
                  details(AppStrings.category + " :", task.category),
                ],
              ),
            ),
          ));
}

details(String titleText, String valueText) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            titleText,
            style: AppStyles.isMobileTextStyle(
                Constant.isDark ? AppColors.whiteColor : AppColors.blackColor),
          ),
        ),
        Expanded(
          child: Text(
            valueText,
            style: AppStyles.isMobileTextStyle(
                Constant.isDark ? AppColors.whiteColor : AppColors.blackColor),
          ),
        ),
      ],
    ),
  );
}
