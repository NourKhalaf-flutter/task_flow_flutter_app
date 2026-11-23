import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:task_flow/core/constants/app_colors.dart';
import 'package:task_flow/features/tasks/domain/entities/task.dart';
import 'package:task_flow/features/tasks/presentation/provider/tasks_provider.dart';

class HeroProgressCard extends StatelessWidget {
  const HeroProgressCard({super.key});

  String _getMotivationalMessage(int completed, int total) {
    if (total == 0) return 'Add your first task to get started ✨';
    if (completed == total) return "All tasks done! You're a rockstar! 🎉";
    final double ratio = completed / total;
    if (ratio >= 0.5) return "You're on fire today! 🔥";
    return 'Keep pushing forward! 💪';
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    // Monday of current week
    final monday = now.subtract(Duration(days: now.weekday - 1));
    final weekDays = List.generate(7, (i) => monday.add(Duration(days: i)));

    return Consumer<TasksProvider>(
      builder: (context, taskProvider, child) {
        final tasks = taskProvider.tasks;
        final totalTasks = tasks.length;
        final completedTasks =
            tasks.where((t) => t.status == TaskStatus.completed).length;
        final double progress =
            totalTasks > 0 ? (completedTasks / totalTasks).clamp(0.0, 1.0) : 0.0;
        final int percentage = (progress * 100).toInt();

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF6366F1), // Electric Indigo
                Color(0xFF4F46E5), // Deep Indigo
                Color(0xFF4338CA), // Royal Violet
              ],
            ),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF6366F1).withValues(alpha: 0.35),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Section: Stats & Circular Progress
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Text Details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.18),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.auto_awesome_rounded,
                                size: 12,
                                color: Colors.white,
                              ),
                              SizedBox(width: 5),
                              Text(
                                "DAILY PROGRESS",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          '$completedTasks of $totalTasks completed',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.2,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _getMotivationalMessage(completedTasks, totalTasks),
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.85),
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 14),
                  // Circular Progress Indicator
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 62,
                        height: 62,
                        child: CircularProgressIndicator(
                          value: progress,
                          strokeWidth: 6,
                          backgroundColor: Colors.white.withValues(alpha: 0.2),
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                          strokeCap: StrokeCap.round,
                        ),
                      ),
                      Text(
                        '$percentage%',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 18),
              // Subtle separator
              Divider(
                color: Colors.white.withValues(alpha: 0.2),
                height: 1,
              ),
              const SizedBox(height: 14),
              // Week Days Row (M T W T F S S)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: weekDays.map((day) {
                  final isToday = day.day == now.day &&
                      day.month == now.month &&
                      day.year == now.year;
                  final dayLetter =
                      ['M', 'T', 'W', 'T', 'F', 'S', 'S'][day.weekday - 1];

                  return Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: isToday ? 10 : 8,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: isToday
                          ? Colors.white
                          : Colors.white.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(14),
                      border: isToday
                          ? null
                          : Border.all(
                              color: Colors.white.withValues(alpha: 0.15),
                              width: 1,
                            ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          dayLetter,
                          style: TextStyle(
                            color: isToday
                                ? const Color(0xFF4F46E5)
                                : Colors.white.withValues(alpha: 0.75),
                            fontSize: 11,
                            fontWeight: isToday
                                ? FontWeight.w800
                                : FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          '${day.day}',
                          style: TextStyle(
                            color: isToday
                                ? const Color(0xFF4F46E5)
                                : Colors.white,
                            fontSize: 12,
                            fontWeight: isToday
                                ? FontWeight.w800
                                : FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        );
      },
    );
  }
}
