import '../entities/task.dart';
import '../repositories/tasks_repository.dart';

class AddTaskUseCase {
  final TasksRepository repository;

  AddTaskUseCase(this.repository);

  Future<void> call(Task task) async {
    await repository.addTask(task);
  }
}