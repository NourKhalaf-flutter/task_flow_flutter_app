import '../repositories/tasks_repository.dart';

class DeleteTaskUseCase {
  final TasksRepository repository;

  DeleteTaskUseCase(this.repository);

  Future<void> call(String taskId) async {
    return await repository.deleteTask(taskId);
  }
}
