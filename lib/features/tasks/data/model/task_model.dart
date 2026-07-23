import 'package:task_flow/features/tasks/domain/entities/task.dart';

class TaskModel extends Task {
  TaskModel({
    required super.id,
    required super.title,
    required super.description,
    required super.createdAt,
     required super.dueDate,
    required super.status,
    required super.priority,
    super.categoryId,
    super.completedAt,
   
  });
 
 
 


  factory TaskModel.fromMap(Map<String, dynamic> map) {
    return TaskModel(
      id: map['id'] as String,
      title: map['title'] as String,
      description: map['description'] as String,

      createdAt: DateTime.parse(
        map['createdAt'] as String,
      ),
      dueDate: DateTime.parse(
        map['dueDate'] as String,
      ),
      
      completedAt: map['completedAt'] != null
          ? DateTime.parse(
              map['completedAt'] as String,
            )
          : null,

      status: TaskStatus.values.byName(
        map['status'],
      ),

      priority: Priority.values.byName(
        map['priority'],
      ),
  
      categoryId: map['categoryId'] as String?,
    );
  }


  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,

      'createdAt': createdAt.toIso8601String(),
       'dueDate': dueDate.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),

      'status': status.name,

      'priority': priority.name,

      'categoryId': categoryId,
    };
  }
}
 
