import 'package:demo_task_manager/model/task_model.dart';
import 'package:demo_task_manager/services/task_services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// State class that holds the list of tasks, loading state, and error
class TaskState {
  final List<TaskModel> tasks;
  final bool isLoading;
  final String? error;

  TaskState({
    required this.tasks,
    required this.isLoading,
    this.error,
  });

  TaskState.initial()
      : tasks = [],
        isLoading = false,
        error = null;

  TaskState copyWith({
    List<TaskModel>? tasks,
    bool? isLoading,
    String? error,
  }) {
    return TaskState(
      tasks: tasks ?? this.tasks,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

class TaskViewModel extends StateNotifier<TaskState> {
  final TaskService _taskService;

  TaskViewModel(this._taskService) : super(TaskState.initial());

  // Load tasks from the database
  Future<void> loadTasks() async {
    state = state.copyWith(isLoading: true);
    try {
      final tasks = await _taskService.getTasks();
      state = state.copyWith(tasks: tasks, isLoading: false);
    } catch (e) {
      state = state.copyWith(error: 'Error fetching tasks', isLoading: false);
    }
  }

  // Add a new task
  Future<void> addTask(TaskModel task) async {
    try {
      await _taskService.insertTask(task);
      loadTasks(); // Refresh the task list after adding
    } catch (e) {
      state = state.copyWith(error: 'Error adding task');
    }
  }

  // Update a task
  Future<void> updateTask(TaskModel task) async {
    try {
      await _taskService.updateTask(task);
      loadTasks(); // Refresh the task list after updating
    } catch (e) {
      state = state.copyWith(error: 'Error updating task');
    }
  }

  // Delete a task
  Future<void> deleteTask(int id) async {
    try {
      await _taskService.deleteTask(id);
      loadTasks(); // Refresh the task list after deleting
    } catch (e) {
      state = state.copyWith(error: 'Error deleting task');
    }
  }
}

// Riverpod provider to access TaskViewModel
final taskViewModelProvider =
    StateNotifierProvider<TaskViewModel, TaskState>((ref) {
  final taskService = ref.watch(taskServiceProvider);
  return TaskViewModel(taskService);
});

// Provider for the TaskService
final taskServiceProvider = Provider<TaskService>((ref) {
  final service = TaskService();
  service.initDatabase(); // Initialize the database
  return service;
});
