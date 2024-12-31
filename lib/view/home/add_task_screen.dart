import 'package:demo_task_manager/model/task_model.dart';
import 'package:demo_task_manager/services/notification_services.dart';
import 'package:demo_task_manager/utils/app_colors.dart';
import 'package:demo_task_manager/utils/app_strings.dart';
import 'package:demo_task_manager/utils/app_styles.dart';
import 'package:demo_task_manager/utils/constant.dart';
import 'package:demo_task_manager/view_model/task_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _category;
  DateTime? reminderDateTime;
  DateTime reminderDate = DateTime.now();
  TimeOfDay reminderTime = const TimeOfDay(hour: 00, minute: 00);
  String? _newCategory;
  final List<String> _categories = ['General', 'Work', 'Personal', 'Urgent'];
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SingleChildScrollView(
        child: Consumer(builder: (context, WidgetRef ref, child) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black,
                  offset: Offset(6, 6),
                  spreadRadius: 2,
                  blurStyle: BlurStyle.solid,
                ),
              ],
            ),
            padding: const EdgeInsets.all(12.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Align(
                    alignment: Alignment.topRight,
                    child: CloseButton(),
                  ),
                  const Center(
                    child: Text(
                      AppStrings.addTask,
                      style: AppStyles.headingTextStyle,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    margin: const EdgeInsets.only(top: 8),
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
                      validator: (value) =>
                          value == null ? 'Please select a category' : null,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text("Task Title", style: AppStyles.isMobileTextStyle),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: titleController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                    ),
                    onChanged: (value) {},
                    validator: (value) =>
                        value!.isEmpty ? 'Please enter a task title' : null,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Task Description",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: descriptionController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                    ),
                    onChanged: (value) {},
                    validator: (value) => value!.isEmpty
                        ? 'Please enter a task description'
                        : null,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Reminder Timing",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    readOnly: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                    ),
                    onTap: () async {
                      pickDateAndTime();
                    },
                    controller: TextEditingController(
                        text: reminderDateTime != null
                            ? '${reminderDateTime!.year}/${reminderDateTime!.month}/${reminderDateTime!.day} ${reminderDateTime!.hour}:${reminderDateTime!.minute}'
                            : 'Select Reminder Date'),
                    validator: (value) =>
                        value!.isEmpty ? 'Please pick a reminder date' : null,
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          if (_category == 'Other' &&
                              _newCategory != null &&
                              _newCategory!.isNotEmpty) {
                            _categories.add(_newCategory!);
                            _category = _newCategory;
                          }

                          final task = Task(
                            title: titleController.text,
                            description: descriptionController.text,
                            reminderTime: reminderDateTime ?? DateTime.now(),
                            category: _category ?? "",
                          );
                          print("task ${reminderDateTime!.hour}");

                          ref.read(taskNotifierProvider.notifier).addTask(task);
                          Navigator.pop(context);
                        }
                      },
                      style: ButtonStyle(
                        // backgroundColor:
                        //     const WidgetStatePropertyAll(AppColors.blueColor),
                        shape: WidgetStatePropertyAll(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                      child: const Text(
                        'Save',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Future pickDateAndTime() async {
    print('object');
    DateTime? date = await pickDate();
    if (date == null) return;

    TimeOfDay? time = await pickTime();
    if (time == null) return;

    final dateTime =
        DateTime(date.year, date.month, date.day, time.hour, time.minute);
    if (dateTime != null && dateTime != reminderDateTime) {
      setState(() {
        reminderDateTime = dateTime;
      });
    }
    print("reminderDateTime - ${reminderDateTime}");
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
    print("pickedTime - $pickedTime");

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
    print("pickedDate - $pickedDate");

    return pickedDate;
  }
}
