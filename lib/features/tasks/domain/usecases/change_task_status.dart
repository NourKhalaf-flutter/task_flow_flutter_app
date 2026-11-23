import '../entities/task.dart';
import '../repositories/tasks_repository.dart';

class ChangeTaskStatusUseCase {
  final TasksRepository repository;

  ChangeTaskStatusUseCase(this.repository);

  Future<void> call(String taskId, TaskStatus status) async {
    await repository.changeTaskStatus(taskId, status);
  }
}
