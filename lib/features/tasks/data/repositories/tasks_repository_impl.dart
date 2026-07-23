import '../../domain/entities/task.dart';
import '../../domain/repositories/tasks_repository.dart';
import '../datasources/tasks_remote_data_source.dart';
import '../model/task_model.dart';

class TasksRepositoryImpl implements TasksRepository {
  final TasksRemoteDataSource remoteDataSource;

  TasksRepositoryImpl(this.remoteDataSource);

  @override
  Future<void> addTask(Task task) async {
    final taskModel = TaskModel(
      id: task.id,
      title: task.title,
      description: task.description,
      createdAt: task.createdAt,
      dueDate: task.dueDate,
      completedAt: task.completedAt,
      status: task.status,
      priority: task.priority,
      categoryId: task.categoryId,
    );

    await remoteDataSource.addTask(taskModel);
  }

  @override
  Future<void> deleteTask(String taskId) {
    // TODO: implement deleteTask
    throw UnimplementedError();
  }

  @override
  Future<List<Task>> getTasks() async {
    final tasksModel = await remoteDataSource.getTasks();

    return tasksModel.map((model) {
      return Task(
        id: model.id,
        title: model.title,
        description: model.description,
        createdAt: model.createdAt,
        status: model.status,
        priority: model.priority,
        dueDate: model.dueDate,
        categoryId: model.categoryId
      );
    }).toList();
  }

  @override
  Future<void> updateTask(Task task) {
    // TODO: implement updateTask
    throw UnimplementedError();
  }
}
