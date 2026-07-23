import '../entities/task.dart';
import '../repositories/tasks_repository.dart';

class GetTasksUseCase {
  final TasksRepository repository;

  GetTasksUseCase(this.repository);

  Future<List<Task>> call( )   {
    return repository.getTasks();
  }
}
