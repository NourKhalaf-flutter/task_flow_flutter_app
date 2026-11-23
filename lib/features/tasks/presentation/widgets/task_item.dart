import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:task_flow/core/constants/app_colors.dart';
import 'package:task_flow/core/constants/app_text_styles.dart';
import 'package:task_flow/core/routes/route_names.dart';
import 'package:task_flow/features/category/domain/entities/category.dart';
import 'package:task_flow/features/category/presentation/widgets/category_card.dart';

import '../../domain/entities/task.dart';
import '../provider/tasks_provider.dart';

class TaskItem extends StatelessWidget {
  final Task task;
  final Category? category;

  const TaskItem({super.key, required this.task, this.category});

  bool get isCompleted => task.status == TaskStatus.completed;

  Widget _buildPriorityBadge(Priority priority) {
    Color bg;
    Color color;
    String label;

    switch (priority) {
      case Priority.high:
        bg = const Color(0x1AEF4444); // Red with 10% opacity
        color = const Color(0xFFEF4444);
        label = '● High';
        break;
      case Priority.medium:
        bg = const Color(0x1AF59E0B); // Amber with 10% opacity
        color = const Color(0xFFF59E0B);
        label = '● Medium';
        break;
      case Priority.low:
        bg = const Color(0x1A3B82F6); // Blue with 10% opacity
        color = const Color(0xFF3B82F6);
        label = '● Low';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.2,
        ),
      ),
    );
  }

  Widget _buildSwipeBackground({
    required Color color,
    required IconData icon,
    required String label,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 22),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      alignment: Alignment.centerRight,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          const SizedBox(width: 8),
          Icon(icon, color: Colors.white, size: 24),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(task.id),
      direction: DismissDirection.endToStart,
      background: _buildSwipeBackground(
        color: AppColors.red,
        icon: Icons.delete_outline_rounded,
        label: 'Delete',
      ),
      confirmDismiss: (direction) async {
        return await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: const Text('Delete Task?'),
            content: Text('Are you sure you want to delete "${task.title}"?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: const Text('Cancel'),
              ),
              FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.red,
                ),
                onPressed: () => Navigator.pop(ctx, true),
                child: const Text('Delete'),
              ),
            ],
          ),
        ) ??
        false;
      },
      onDismissed: (_) {
        context.read<TasksProvider>().deleteTask(task.id);
      },
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(
            context,
            RouteNames.taskDetailsScreen,
            arguments: task,
          );
        },
        borderRadius: BorderRadius.circular(20),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(vertical: 6),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isCompleted
                ? AppColors.cardSurface.withValues(alpha: 0.7)
                : AppColors.cardSurface,
            borderRadius: BorderRadius.circular(20),
            border: AppColors.subtleCardBorder,
            boxShadow: isCompleted ? [] : AppColors.softShadow,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Metadata Row: Priority Badge + Category Pill + Due Date
              Row(
                children: [
                  _buildPriorityBadge(task.priority),
                  if (category != null) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: Color(category!.color).withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            CategoryCard.getCategoryIcon(category!.name),
                            size: 11,
                            color: Color(category!.color),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            category!.name,
                            style: TextStyle(
                              color: Color(category!.color),
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  const Spacer(),
                  // Due Date
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.calendar_today_outlined,
                        size: 13,
                        color: isCompleted
                            ? Colors.grey.shade400
                            : AppColors.secondColor,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        DateFormat('dd MMM').format(task.dueDate),
                        style: TextStyle(
                          color: isCompleted
                              ? Colors.grey.shade400
                              : AppColors.secondColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Main Row: Interactive Checkbox + Title & Description
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Interactive Checkbox
                  GestureDetector(
                    onTap: () async {
                      await context.read<TasksProvider>().changeTaskStatus(
                        task.id,
                        isCompleted ? TaskStatus.todo : TaskStatus.completed,
                      );
                    },
                    behavior: HitTestBehavior.opaque,
                    child: Container(
                      width: 24,
                      height: 24,
                      margin: const EdgeInsets.only(top: 2, right: 12),
                      decoration: BoxDecoration(
                        color: isCompleted
                            ? AppColors.mintAccent
                            : Colors.transparent,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isCompleted
                              ? AppColors.mintAccent
                              : Colors.grey.shade300,
                          width: 2,
                        ),
                        boxShadow: isCompleted
                            ? [
                                BoxShadow(
                                  color: AppColors.mintAccent
                                      .withValues(alpha: 0.35),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ]
                            : null,
                      ),
                      child: isCompleted
                          ? const Icon(
                              Icons.check_rounded,
                              size: 15,
                              color: Colors.white,
                            )
                          : null,
                    ),
                  ),
                  // Content (Title + Description)
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          task.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.font16MainSans.copyWith(
                            fontWeight: FontWeight.w600,
                            color: isCompleted
                                ? AppColors.secondColor.withValues(alpha: 0.5)
                                : AppColors.mainColor,
                            decoration: isCompleted
                                ? TextDecoration.lineThrough
                                : null,
                            decorationColor: AppColors.secondColor,
                            decorationThickness: 2,
                          ),
                        ),
                        if (task.description.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            task.description,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: isCompleted
                                  ? Colors.grey.shade400
                                  : Colors.grey.shade600,
                              fontSize: 13,
                              height: 1.4,
                              decoration: isCompleted
                                  ? TextDecoration.lineThrough
                                  : null,
                              decorationColor: Colors.grey.shade400,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 14,
                    color: Colors.grey.shade300,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
