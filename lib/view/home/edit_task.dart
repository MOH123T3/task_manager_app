import 'package:demo_task_manager/model/task_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../view_model/task_view_model.dart';

class EditTaskPage extends StatefulWidget {
  final Task task;
  EditTaskPage({required this.task});

  @override
  _EditTaskPageState createState() => _EditTaskPageState();
}

class _EditTaskPageState extends State<EditTaskPage> {
  late TextEditingController titleController;
  late TextEditingController descriptionController;
  late DateTime reminderTime;
  late String category;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.task.title);
    descriptionController =
        TextEditingController(text: widget.task.description);
    reminderTime = widget.task.reminderTime;
    category = widget.task.category;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Task'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Consumer(builder: (context, WidgetRef ref, child) {
          return Column(
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
              ),
              TextField(
                onTap: () async {
                  DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: reminderTime,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (picked != null && picked != reminderTime) {
                    setState(() {
                      reminderTime = picked;
                    });
                  }
                },
                readOnly: true,
                controller: TextEditingController(
                    text: '${reminderTime.toLocal()}'.split(' ')[0]),
                decoration: InputDecoration(labelText: 'Reminder Time'),
              ),
              DropdownButton<String>(
                value: category,
                onChanged: (value) {
                  setState(() {
                    category = value!;
                  });
                },
                items: ['General', 'Work', 'Personal', 'Urgent']
                    .map((category) => DropdownMenuItem<String>(
                          value: category,
                          child: Text(category),
                        ))
                    .toList(),
              ),
              ElevatedButton(
                onPressed: () {
                  final updatedTask = Task(
                    id: widget.task.id,
                    title: titleController.text,
                    description: descriptionController.text,
                    reminderTime: reminderTime,
                    category: category,
                  );
                  ref
                      .read(taskNotifierProvider.notifier)
                      .updateTask(updatedTask);

                  Navigator.pop(context);
                },
                child: Text('Update Task'),
              ),
            ],
          );
        }),
      ),
    );
  }
}
