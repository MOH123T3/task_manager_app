import 'package:demo_task_manager/model/task_model.dart';
import 'package:demo_task_manager/services/task_services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TaskNotifier extends StateNotifier<AsyncValue<List<Task>>> {
  TaskNotifier() : super(const AsyncValue.loading());

  // Fetch all tasks
  Future<void> fetchTasks() async {
    state = const AsyncValue.loading();
    try {
      final tasks = await DatabaseHelper.instance.getAllTasks();
      state = AsyncValue.data(tasks);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  // Add a new task
  Future<void> addTask(Task task) async {
    try {
      await DatabaseHelper.instance.insertTask(task);
      fetchTasks(); // Refresh the list after adding
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  // Update an existing task
  Future<void> updateTask(Task task) async {
    try {
      await DatabaseHelper.instance.updateTask(task);
      fetchTasks(); // Refresh the list after updating
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  // Delete a task
  Future<void> deleteTask(int id) async {
    try {
      await DatabaseHelper.instance.deleteTask(id);
      fetchTasks(); // Refresh the list after deletion
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}

// Provider for TaskNotifier
final taskNotifierProvider =
    StateNotifierProvider<TaskNotifier, AsyncValue<List<Task>>>((ref) {
  return TaskNotifier();
});
