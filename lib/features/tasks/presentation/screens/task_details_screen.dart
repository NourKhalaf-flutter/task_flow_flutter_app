import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:task_flow/core/constants/app_colors.dart';
import 'package:task_flow/core/constants/app_text_styles.dart';
import 'package:task_flow/core/routes/route_names.dart';
import 'package:task_flow/core/widgets/button_widget.dart';
import 'package:task_flow/features/category/domain/entities/category.dart';
import 'package:task_flow/features/category/presentation/provider/categories_provider.dart';
import 'package:task_flow/features/category/presentation/widgets/category_card.dart';
import 'package:task_flow/features/tasks/domain/entities/task.dart';
import 'package:task_flow/features/tasks/presentation/provider/tasks_provider.dart';

class TaskDetailsScreen extends StatefulWidget {
  final Task task;
  final Category? category;

  const TaskDetailsScreen({super.key, required this.task, this.category});

  @override
  State<TaskDetailsScreen> createState() => _TaskDetailsScreenState();
}

class _TaskDetailsScreenState extends State<TaskDetailsScreen> {
  late Task _currentTask;

  @override
  void initState() {
    super.initState();
    _currentTask = widget.task;
  }

  bool get isCompleted => _currentTask.status == TaskStatus.completed;

  Widget _buildPriorityBadge(Priority priority) {
    Color bg;
    Color color;
    String label;

    switch (priority) {
      case Priority.high:
        bg = const Color(0x1AEF4444);
        color = const Color(0xFFEF4444);
        label = '● High Priority';
        break;
      case Priority.medium:
        bg = const Color(0x1AF59E0B);
        color = const Color(0xFFF59E0B);
        label = '● Medium Priority';
        break;
      case Priority.low:
        bg = const Color(0x1A3B82F6);
        color = const Color(0xFF3B82F6);
        label = '● Low Priority';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.2,
        ),
      ),
    );
  }

  Future<void> _confirmDelete() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Delete Task?'),
        content: Text('Are you sure you want to delete "${_currentTask.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppColors.red),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm == true && mounted) {
      await context.read<TasksProvider>().deleteTask(_currentTask.id);
      if (mounted) {
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final category = context
        .watch<CategoriesProvider>()
        .getCategoryById(_currentTask.categoryId);

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColors.mainColor,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Task Details',
          style: AppTextStyles.font18MainInter500.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined, color: AppColors.mainColor),
            tooltip: 'Edit Task',
            onPressed: () async {
              final result = await Navigator.pushNamed(
                context,
                RouteNames.addTaskScreen,
                arguments: _currentTask,
              );
              if (result is Task && mounted) {
                setState(() {
                  _currentTask = result;
                });
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline_rounded, color: AppColors.red),
            tooltip: 'Delete Task',
            onPressed: _confirmDelete,
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Status Indicator Banner (Only shown when task is completed)
              if (isCompleted) ...[
                Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: AppColors.mintAccent.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppColors.mintAccent.withValues(alpha: 0.3),
                    ),
                  ),
                  child: const Row(
                    children: [
                      Icon(
                        Icons.check_circle_rounded,
                        color: AppColors.mintAccent,
                        size: 20,
                      ),
                      SizedBox(width: 10),
                      Text(
                        'Completed Task 🎉',
                        style: TextStyle(
                          color: AppColors.mintAccent,
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],
              if(!isCompleted)(SizedBox(height: 36,)),
              // Title (Direct & Box-Free)
              Text(
                _currentTask.title,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: isCompleted
                      ? AppColors.secondColor.withValues(alpha: 0.6)
                      : AppColors.mainColor,
                  decoration:
                      isCompleted ? TextDecoration.lineThrough : null,
                  height: 1.3,
                  letterSpacing: -0.4,
                ),
              ),

              const SizedBox(height: 10),

              // Description (Direct & Box-Free)
              if (_currentTask.description.trim().isNotEmpty) ...[
                Text(
                  _currentTask.description,
                  style: const TextStyle(
                    fontSize: 15,
                    color: AppColors.secondColor,
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 20),
              ] else ...[
                const SizedBox(height: 10),
              ],

              // Priority & Due Date Cards Row
              Row(
                children: [
                  // Priority
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.cardSurface,
                        borderRadius: BorderRadius.circular(16),
                        border: AppColors.subtleCardBorder,
                        boxShadow: AppColors.softShadow,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Priority',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.secondColor,
                            ),
                          ),
                          const SizedBox(height: 8),
                          _buildPriorityBadge(_currentTask.priority),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Due Date
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.cardSurface,
                        borderRadius: BorderRadius.circular(16),
                        border: AppColors.subtleCardBorder,
                        boxShadow: AppColors.softShadow,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Due Date',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.secondColor,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            DateFormat('dd MMM yyyy').format(_currentTask.dueDate),
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: AppColors.mainColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 22),

              // Category Section
              const Text(
                'CATEGORY',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.secondColor,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 8),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: AppColors.cardSurface,
                  borderRadius: BorderRadius.circular(16),
                  border: AppColors.subtleCardBorder,
                  boxShadow: AppColors.softShadow,
                ),
                child: Row(
                  children: [
                    if (category != null) ...[
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Color(category.color).withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          CategoryCard.getCategoryIcon(category.name, category.icon),
                          size: 16,
                          color: Color(category.color),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        category.name,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.mainColor,
                        ),
                      ),
                    ] else ...[
                      const Icon(
                        Icons.folder_open_rounded,
                        size: 18,
                        color: AppColors.secondColor,
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        'No category assigned',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.secondColor,
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              const SizedBox(height: 36),

              // Bottom Action Button
              ButtonWidget(
                content: isCompleted ? 'REOPEN TASK' : 'COMPLETE TASK',
                onPressed: () async {
                  final newStatus = isCompleted
                      ? TaskStatus.todo
                      : TaskStatus.completed;
                  await context.read<TasksProvider>().changeTaskStatus(
                        _currentTask.id,
                        newStatus,
                      );
                  setState(() {
                    _currentTask = _currentTask.copyWith(
                      status: newStatus,
                      completedAt: newStatus == TaskStatus.completed
                          ? DateTime.now()
                          : null,
                    );
                  });
                },
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
