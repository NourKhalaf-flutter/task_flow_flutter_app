import 'package:flutter/material.dart';
import 'package:task_flow/features/tasks/domain/entities/task.dart';
import 'package:task_flow/features/tasks/domain/usecases/delete_task.dart';
import 'package:task_flow/features/tasks/domain/usecases/get_tasks.dart';
import 'package:task_flow/features/tasks/domain/usecases/update_task.dart';

import '../../domain/usecases/add_task.dart';
import '../../domain/usecases/change_task_status.dart';

class TasksProvider extends ChangeNotifier {
  final AddTaskUseCase addTaskUseCase;
  final GetTasksUseCase getTasksUseCase;
  final ChangeTaskStatusUseCase changeTaskStatusUseCase;
  final DeleteTaskUseCase deleteTaskUseCase;
  final UpdateTaskUseCase updateTaskUseCase;

  TasksProvider({
    required this.addTaskUseCase,
    required this.getTasksUseCase,
    required this.changeTaskStatusUseCase,
    required this.deleteTaskUseCase,
    required this.updateTaskUseCase,
  });
  bool isLoading = false;
  String? errorMessage;

  List<Task> tasks = [];
  String? selectedCategoryId;

  void selectCategory(String? categoryId) {
  selectedCategoryId = categoryId;
  notifyListeners();
}

List<Task> get filteredTasks {
  
  if (selectedCategoryId == null) {
    return tasks;
  }

  return tasks.where(
    (task) => task.categoryId == selectedCategoryId,
  ).toList();
}

  Future<void> getTasks() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
       tasks = await getTasksUseCase();
       for (var task in tasks) {
  print("Provider task categoryId: ${task.categoryId}  ");
}
    } catch (e) {
      errorMessage = e.toString();
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> addTask(Task task) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      await addTaskUseCase(task);
      await getTasks();
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateTask(Task task) async {
    final index = tasks.indexWhere((t) => t.id == task.id);
    if (index != -1) {
      tasks[index] = task;
      notifyListeners();
    }

    try {
      await updateTaskUseCase(task);
    } catch (e) {
      errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<void> deleteTask(String taskId) async {
    final index = tasks.indexWhere((t) => t.id == taskId);
    if (index == -1) return;

    final removedTask = tasks.removeAt(index);
    notifyListeners();

    try {
      await deleteTaskUseCase(taskId);
    } catch (e) {
      tasks.insert(index, removedTask);
      errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<void> changeTaskStatus(
    String taskId,
    TaskStatus status,
  ) async {
    final index = tasks.indexWhere((t) => t.id == taskId);
    if (index == -1) return;

    final oldTask = tasks[index];
    // Optimistic Update: update in-memory immediately for smooth 60fps UX
    tasks[index] = oldTask.copyWith(
      status: status,
      completedAt: status == TaskStatus.completed ? DateTime.now() : null,
    );
    notifyListeners();

    try {
      await changeTaskStatusUseCase(taskId, status);
    } catch (e) {
      // Rollback if request fails
      tasks[index] = oldTask;
      errorMessage = e.toString();
      notifyListeners();
    }
  }
}
