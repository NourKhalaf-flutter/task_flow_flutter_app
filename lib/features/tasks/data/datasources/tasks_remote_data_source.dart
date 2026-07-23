import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../model/task_model.dart';
 
abstract class TasksRemoteDataSource {
  Future<void> addTask(TaskModel task);
    Future<List<TaskModel>> getTasks( );
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

    print("Firestore data: ${doc.data()}");
    print("categoryId from firestore: ${doc.data()['categoryId']}");

     final task = TaskModel.fromMap(doc.data());

  print("Model categoryId: ${task.categoryId}");

  return task;
    }).toList();
  }
}