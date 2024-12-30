import 'package:demo_task_manager/model/task_model.dart';
import 'package:demo_task_manager/view_model/task_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TaskListScreen extends ConsumerWidget {
  const TaskListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final taskState = ref.watch(taskViewModelProvider);

    if (taskState.isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Task Manager')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (taskState.error != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Task Manager')),
        body: Center(child: Text('Error: ${taskState.error}')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Manager'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              _showTaskDialog(context, ref);
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: taskState.tasks.length,
        itemBuilder: (context, index) {
          final task = taskState.tasks[index];
          return ListTile(
            title: Text(task.title),
            subtitle: Text(task.description),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                ref.read(taskViewModelProvider.notifier).deleteTask(task.id!);
              },
            ),
            onTap: () {
              _showTaskDialog(context, ref, task);
            },
          );
        },
      ),
    );
  }

  // Method to show a dialog to add or edit a task
  void _showTaskDialog(BuildContext context, WidgetRef ref, [TaskModel? task]) {
    final titleController = TextEditingController(text: task?.title ?? '');
    final descriptionController =
        TextEditingController(text: task?.description ?? '');

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(task == null ? 'Add Task' : 'Edit Task'),
        content: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              final newTask = TaskModel(
                id: task?.id,
                title: titleController.text,
                description: descriptionController.text,
              );
              if (task == null) {
                ref.read(taskViewModelProvider.notifier).addTask(newTask);
              } else {
                ref.read(taskViewModelProvider.notifier).updateTask(newTask);
              }
              Navigator.of(context).pop();
            },
            child: Text(task == null ? 'Add' : 'Update'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }
}
