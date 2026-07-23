class Task  {
  final String id;
  final String title;
  final String description;

  final DateTime createdAt;
   final DateTime  dueDate;
  final DateTime? completedAt;

  final TaskStatus status;
  final Priority priority;
  final String? categoryId;

  Task ({
    required this.id,
    required this.title,
    required this.description,
    required this.createdAt,
    this.completedAt,
    required this.status,
    required this.priority,
    this.categoryId,
    required this.dueDate
  });
}

enum TaskStatus { todo, inProgress, completed }

enum Priority { low, medium, high }

 

