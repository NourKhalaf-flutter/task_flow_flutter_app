class Task {
  final String id;
  final String title;
  final String description;

  final DateTime createdAt;
  final DateTime dueDate;
  final DateTime? completedAt;

  final TaskStatus status;
  final Priority priority;
  final String? categoryId;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.createdAt,
    this.completedAt,
    required this.status,
    required this.priority,
    this.categoryId,
    required this.dueDate,
  });

  Task copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? createdAt,
    DateTime? dueDate,
    DateTime? completedAt,
    TaskStatus? status,
    Priority? priority,
    String? categoryId,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      dueDate: dueDate ?? this.dueDate,
      completedAt: completedAt ?? this.completedAt,
      status: status ?? this.status,
      priority: priority ?? this.priority,
      categoryId: categoryId ?? this.categoryId,
    );
  }
}

enum TaskStatus { todo, inProgress, completed }

enum Priority { low, medium, high }
