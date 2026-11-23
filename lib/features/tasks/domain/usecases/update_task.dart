import '../entities/task.dart';
import '../repositories/tasks_repository.dart';

class UpdateTaskUseCase {
  final TasksRepository repository;

  UpdateTaskUseCase(this.repository);

  Future<void> call(Task task) async {
    return await repository.updateTask(task);
  }
}
