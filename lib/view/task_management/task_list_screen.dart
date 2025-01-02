import 'package:task_manager/utils/app_colors.dart';
import 'package:task_manager/utils/app_strings.dart';
import 'package:task_manager/utils/app_styles.dart';
import 'package:task_manager/utils/constant.dart';
import 'package:task_manager/utils/responsive.dart';
import 'package:task_manager/view/task_management/detail_task_screen.dart';
import 'package:task_manager/view/task_management/edit_task_screen.dart';
import 'package:task_manager/view_model/task_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

// ignore: must_be_immutable
class TaskListPage extends ConsumerWidget {
  TaskListPage({super.key});

  // TextEditingController to handle the search input
  TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final taskState = ref.watch(taskNotifierProvider);

    //Todo FOr Getting isDark bool from  Theme initialization
    return ValueListenableBuilder(
        valueListenable: Hive.box('theme').listenable(),
        builder: (context, box, child) {
          final isDark = box.get('isDark', defaultValue: false);
          Constant.isDark = isDark;
          return Column(
            children: [
              // Search bar
              Padding(
                padding: const EdgeInsets.all(18.0),
                // Get the filtered list of items from the Riverpod state

                child: TextField(
                  style: TextStyle(
                      color:
                          isDark ? AppColors.whiteColor : AppColors.blackColor),
                  controller: _searchController,
                  onChanged: (query) {
                    // Call the filter function when the query changes
                    ref.read(taskNotifierProvider.notifier).filterTasks(query);
                  },
                  decoration: InputDecoration(
                    labelText: 'Search',
                    floatingLabelStyle: TextStyle(
                        color: isDark
                            ? AppColors.whiteColor
                            : AppColors.blackColor),
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              // Display different states based on AsyncValue
              Expanded(
                child: taskState.when(
                  //Todo when data is loading
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  //Todo when data is loaded
                  data: (tasks) {
                    // when data is empty
                    if (tasks.isEmpty) {
                      return Center(
                        child: ListView(
                          children: [
                            Center(
                              child: Text(
                                AppStrings.noDataFound,
                                style: TextStyle(
                                  color: isDark
                                      ? AppColors.lightAccentColor
                                      : AppColors.darkAccentColor,
                                ),
                              ),
                            ),
                            SizedBox(height: 15),
                            Icon(Icons.hourglass_empty,
                                color: isDark
                                    ? AppColors.whiteColor
                                    : AppColors.blackColor)
                          ],
                        ),
                      );
                    } else {
//Todo for mobile ui
                      return Responsive(
                        mobile: ListView.builder(
                          itemCount: tasks.length,
                          itemBuilder: (context, index) {
                            final task = tasks[index];
                            return Card(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 8),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      showDetailsTaskDialog(context, task);
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Title : " "${task.title}",
                                              style: isDark
                                                  ? AppStyles
                                                      .darkThemeTextStyle(18,
                                                          AppColors.blackColor)
                                                  : AppStyles
                                                      .lightThemeTextStyle(18,
                                                          AppColors.whiteColor),
                                            ),
                                            const SizedBox(
                                              height: 15,
                                            ),
                                            Text(
                                                "Date :  " +
                                                    "${task.reminderTime.day}/${task.reminderTime.month}/ ${task.reminderTime.year}",
                                                style: isDark
                                                    ? AppStyles
                                                        .darkThemeTextStyle(
                                                            13,
                                                            AppColors
                                                                .blackColor)
                                                    : AppStyles
                                                        .lightThemeTextStyle(
                                                            13,
                                                            AppColors
                                                                .whiteColor)),
                                            SizedBox(height: 10),
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8,
                                                      vertical: 2),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                  color: task.status ==
                                                          "Pending"
                                                      ? AppColors.redColor
                                                      : AppColors.greenColor),
                                              child: Text(
                                                task.status,
                                                style: AppStyles
                                                    .lightThemeTextStyle(13,
                                                        AppColors.whiteColor),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          width: 15,
                                        ),
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 20),
                                          decoration: BoxDecoration(
                                            color: isDark
                                                ? AppColors.lightAccentColor
                                                : AppColors.darkAccentColor,
                                            borderRadius:
                                                BorderRadius.circular(14),
                                          ),
                                          child: Column(
                                            children: [
                                              IconButton(
                                                  onPressed: () {
                                                    showEditTaskDialog(
                                                        context, ref, task);
                                                  },
                                                  icon: Icon(
                                                    color: isDark
                                                        ? AppColors.whiteColor
                                                        : AppColors.blackColor,
                                                    Icons.edit,
                                                    size: AppStyles
                                                        .isMobileScreenIcon,
                                                  )),
                                              Divider(),
                                              IconButton(
                                                  onPressed: () {
                                                    ref
                                                        .read(
                                                            taskNotifierProvider
                                                                .notifier)
                                                        .deleteTask(task.id!);
                                                  },
                                                  icon: Icon(
                                                    Icons.delete,
                                                    color: isDark
                                                        ? AppColors.whiteColor
                                                        : AppColors.blackColor,
                                                    size: AppStyles
                                                        .isMobileScreenIcon,
                                                  ))
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ));
                          },
                        ),
//Todo for tablet ui
                        tablet: GridView.builder(
                          padding: EdgeInsets.all(8),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 10,
                                  crossAxisCount: 2),
                          itemCount: tasks.length,
                          itemBuilder: (context, index) {
                            final task = tasks[index];
                            return Card(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 8),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(height: 5),
                                      GestureDetector(
                                        onTap: () {
                                          showDetailsTaskDialog(context, task);
                                        },
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  "Title : " "${task.title}",
                                                  style: isDark
                                                      ? AppStyles
                                                          .darkThemeTextStyle(
                                                              18,
                                                              AppColors
                                                                  .blackColor)
                                                      : AppStyles
                                                          .lightThemeTextStyle(
                                                              18,
                                                              AppColors
                                                                  .whiteColor),
                                                ),
                                                Container(
                                                  alignment: Alignment.center,
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 8,
                                                      vertical: 4),
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15),
                                                      color: task.status ==
                                                              "Pending"
                                                          ? AppColors.redColor
                                                          : AppColors
                                                              .greenColor),
                                                  child: Text(
                                                    task.status,
                                                    style: AppStyles
                                                        .lightThemeTextStyle(
                                                            17,
                                                            AppColors
                                                                .whiteColor),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 10),
                                            Divider(),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              "${AppStrings.category}: "
                                              "${task.category}",
                                              style: isDark
                                                  ? AppStyles
                                                      .darkThemeTextStyle(17,
                                                          AppColors.blackColor)
                                                  : AppStyles
                                                      .lightThemeTextStyle(17,
                                                          AppColors.whiteColor),
                                            ),
                                            SizedBox(height: 15),
                                            Text(
                                                "Date :  " +
                                                    "${task.reminderTime.day}/${task.reminderTime.month}/ ${task.reminderTime.year}",
                                                style: isDark
                                                    ? AppStyles
                                                        .darkThemeTextStyle(
                                                            17,
                                                            AppColors
                                                                .blackColor)
                                                    : AppStyles
                                                        .lightThemeTextStyle(
                                                            17,
                                                            AppColors
                                                                .whiteColor)),
                                            const SizedBox(
                                              height: 15,
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        height: 45,
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 15),
                                        decoration: BoxDecoration(
                                          color: isDark
                                              ? AppColors.lightAccentColor
                                              : AppColors.darkAccentColor,
                                          borderRadius:
                                              BorderRadius.circular(14),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            IconButton(
                                                onPressed: () {
                                                  showEditTaskDialog(
                                                      context, ref, task);
                                                },
                                                icon: Icon(
                                                  Icons.edit,
                                                  size: AppStyles
                                                      .isTabletScreenIcon,
                                                  color: isDark
                                                      ? AppColors.whiteColor
                                                      : AppColors.blackColor,
                                                )),
                                            Text("|"),
                                            IconButton(
                                                onPressed: () {
                                                  ref
                                                      .read(taskNotifierProvider
                                                          .notifier)
                                                      .deleteTask(task.id!);
                                                },
                                                icon: Icon(
                                                  Icons.delete,
                                                  size: AppStyles
                                                      .isTabletScreenIcon,
                                                  color: isDark
                                                      ? AppColors.whiteColor
                                                      : AppColors.blackColor,
                                                ))
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ));
                          },
                        ),
                      );
                    }
                  },
                  //Todo getting error
                  error: (error, stack) => Center(
                      child: Text(
                    AppStrings.somethingWentWrong,
                    style: isDark
                        ? AppStyles.darkThemeTextStyle(18, AppColors.whiteColor)
                        : AppStyles.lightThemeTextStyle(
                            18, AppColors.blackColor),
                  )),
                ),
              ),
            ],
          );
        });
  }
}
