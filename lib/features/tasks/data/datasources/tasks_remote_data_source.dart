import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/entities/task.dart';
import '../model/task_model.dart';
 
abstract class TasksRemoteDataSource {
  Future<void> addTask(TaskModel task);
  Future<List<TaskModel>> getTasks();
  Future<void> changeTaskStatus(String taskId, TaskStatus status);
  Future<void> deleteTask(String taskId);
  Future<void> updateTask(TaskModel task);
}

class TasksRemoteDataSourceImpl implements TasksRemoteDataSource {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  TasksRemoteDataSourceImpl({
    required this.firestore,
    required this.auth,
  });

  @override
  Future<void> addTask(TaskModel task) async {
    final user = auth.currentUser;

    if (user == null) {
      throw Exception('User is not logged in.');
    }

    await firestore
        .collection('users')
        .doc(user.uid)
        .collection('tasks')
        .doc(task.id)
        .set(task.toMap());
  }

  
  @override
  Future<List<TaskModel>> getTasks() async {
    final user = auth.currentUser;
    if (user == null) {
      throw Exception('User is not logged in.');
    }
    final snapshot = await firestore
        .collection('users')
        .doc(user.uid)
        .collection('tasks')
        .get();


    return snapshot.docs.map((doc) {
 

     final task = TaskModel.fromMap(doc.data());

  

  return task;
    }).toList();
  }
  
 
  @override
  Future<void> changeTaskStatus(
  String taskId,
  TaskStatus status,
) async {

  final user = auth.currentUser;

  if (user == null) {
    throw Exception("User not logged in");
  }

  await firestore
      .collection('users')
      .doc(user.uid)
      .collection('tasks')
      .doc(taskId)
      .update({
        'status': status.name,
        'completedAt': status == TaskStatus.completed
            ? DateTime.now().toIso8601String()
            : null,
      });
}

  @override
  Future<void> deleteTask(String taskId) async {
    final user = auth.currentUser;
    if (user == null) {
      throw Exception("User not logged in");
    }
    await firestore
        .collection('users')
        .doc(user.uid)
        .collection('tasks')
        .doc(taskId)
        .delete();
  }

  @override
  Future<void> updateTask(TaskModel task) async {
    final user = auth.currentUser;
    if (user == null) {
      throw Exception("User not logged in");
    }
    await firestore
        .collection('users')
        .doc(user.uid)
        .collection('tasks')
        .doc(task.id)
        .update(task.toMap());
  }
}
