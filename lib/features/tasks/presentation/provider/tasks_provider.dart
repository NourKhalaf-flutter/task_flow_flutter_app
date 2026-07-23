import 'package:flutter/material.dart';
import 'package:task_flow/features/tasks/domain/entities/task.dart';
import 'package:task_flow/features/tasks/domain/usecases/get_tasks.dart';

import '../../domain/usecases/add_task.dart';

class TasksProvider extends ChangeNotifier {
  final AddTaskUseCase addTaskUseCase;
  final GetTasksUseCase getTasksUseCase;

  TasksProvider({required this.addTaskUseCase, required this.getTasksUseCase});
  bool isLoading = false;
  String? errorMessage;

  List<Task> tasks = [];
  String? selectedCategoryId;

  void selectCategory(String? categoryId) {
  selectedCategoryId = categoryId;
  notifyListeners();
}

List<Task> get filteredTasks {
   print("filteredTasks called");
  print("selectedCategoryId: $selectedCategoryId");
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

  Future<void> updateTask(Task task) async {}

  Future<void> deleteTask(String taskId) async {}

  Future<void> changeTaskStatus(String taskId, TaskStatus status) async {}
}
