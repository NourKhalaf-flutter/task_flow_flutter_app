import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:task_flow/core/constants/app_text_styles.dart';
import 'package:task_flow/features/category/domain/entities/category.dart';

import '../../domain/entities/task.dart';

class TaskItem extends StatelessWidget {
  final Task task;
  final Category? category;

  const TaskItem({super.key, required this.task, this.category});

  Color _priorityColor(Priority priority) {
    switch (priority) {
      case Priority.high:
        return Colors.redAccent;
      case Priority.medium:
        return Colors.orange;
      case Priority.low:
        return Colors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const .symmetric(vertical: 8,),
      padding: .all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Row(
            children: [
              Text(
                task.priority.name.toUpperCase(),
                style: AppTextStyles.font16MainSans.copyWith(
                  color: _priorityColor(task.priority),
                  fontWeight: .w700,
                ),
              ),
              Spacer(),
              if (category != null) ...[
                Row(
                  children: [
                    Container(
                      width:12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: Color(category!.color),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      category!.name,
                      style: AppTextStyles.font14MainSans,
                    ),
                  ],
                ),
              ],
            ],
          ),
          SizedBox(height: 4),
          Divider(color: Colors.grey.shade200),
          // Category Color Indicator
          const SizedBox(height: 8),
          Row(
            children: [
              Container(
                height: 40,
                width: 4,
                color: _priorityColor(task.priority),
              ),
              SizedBox(width: 8),
              Column(
                children: [
                  Text(
                    task.title,
                    style: AppTextStyles.font18MainInter500,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4),
                  if (task.description.isNotEmpty)
                    Text(
                      task.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        height: 1.4,
                      ),
                    ),
                ],
              ),
            ],
          ),

          /// Description

          //const SizedBox(height: 16),

          // Divider(color: Colors.grey.shade200),
          const SizedBox(height: 12),

          Row(
            children: [
              Icon(
                Icons.calendar_today_outlined,
                size: 16,
                color: Colors.grey.shade600,
              ),

              const SizedBox(width: 6),

              Text(
                DateFormat('dd MMM').format(task.dueDate),
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),

              const Spacer(),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: task.status == TaskStatus.completed
                      ? Colors.green.withValues(alpha: 0.12)
                      : Colors.orange.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  task.status.name,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                    color: task.status == TaskStatus.completed
                        ? Colors.green
                        : Colors.orange,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
