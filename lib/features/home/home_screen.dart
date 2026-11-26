import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:task_flow/core/constants/app_colors.dart';
import 'package:task_flow/core/constants/app_text_styles.dart';
import 'package:task_flow/core/widgets/shimmer_loading.dart';
import 'package:task_flow/features/auth/login_provider.dart';
import 'package:task_flow/features/home/widgets/hero_progress_card.dart';
import 'package:task_flow/features/tasks/domain/entities/task.dart';
import 'package:task_flow/features/tasks/presentation/provider/tasks_provider.dart';

import '../category/presentation/provider/categories_provider.dart';
import '../category/presentation/widgets/category_card.dart';
import '../category/presentation/widgets/create_category_bottom_sheet.dart';
import '../tasks/presentation/widgets/task_item.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<TasksProvider>().getTasks();
      context.read<CategoriesProvider>().getCategories();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top App Bar / User Profile Header
                Consumer2<LoginProvider, TasksProvider>(
                  builder: (context, authProvider, taskProvider, child) {
                    final userName = authProvider.currentUser?.name ?? 'User';
                    final firstLetter =
                        userName.isNotEmpty ? userName[0].toUpperCase() : 'U';
                    final pendingCount = taskProvider.tasks
                        .where((t) => t.status != TaskStatus.completed)
                        .length;
                    final dateStr =
                        DateFormat('EEE, dd MMM').format(DateTime.now());

                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Hello, $userName 👋",
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: AppColors.mainColor,
                                letterSpacing: 0.2,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              "$dateStr • $pendingCount tasks pending",
                              style: const TextStyle(
                                fontSize: 13,
                                color: AppColors.secondColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        // Avatar Badge with Initials
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color:
                                AppColors.primaryAccent.withValues(alpha: 0.12),
                            border: Border.all(
                              color: AppColors.primaryAccent
                                  .withValues(alpha: 0.3),
                              width: 1.5,
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            firstLetter,
                            style: const TextStyle(
                              color: AppColors.primaryAccent,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),

                const SizedBox(height: 20),

                // Hero Progress Card (Bento Gradient Card with Days Tracker)
                const HeroProgressCard(),

                const SizedBox(height: 24),

                // Categories Header Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Categories", style: AppTextStyles.font18MainInter500),
                    InkWell(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (_) => const CreateCategoryBottomSheet(),
                        );
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ), 
                        child: Row(
                          children: [
                            Icon(
                              Icons.add_rounded,
                              size: 18,
                              color: AppColors.primaryAccent,
                            ),
                            SizedBox(width: 4),
                            Text(
                              "New",
                              style: TextStyle(
                                color: AppColors.primaryAccent,
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Categories Horizontal Filter Pills
                Consumer2<CategoriesProvider, TasksProvider>(
                  builder: (context, categoryProvider, taskProvider, child) {
                    if (categoryProvider.isLoading) {
                      return const CategoriesBarShimmer();
                    }

                    return SizedBox(
                      height: 48,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        itemCount: categoryProvider.categories.length + 1,
                        separatorBuilder: (context, index) =>
                            const SizedBox(width: 10),
                        itemBuilder: (context, index) {
                          // Item 0 is 'All'
                          if (index == 0) {
                            return CategoryCard(
                              title: 'All',
                              color: AppColors.primaryAccent.toARGB32(),
                              taskCount:
                                  context.read<TasksProvider>().tasks.length,
                              isSelected:
                                  taskProvider.selectedCategoryId == null,
                              onTap: () {
                                taskProvider.selectCategory(null);
                              },
                            );
                          }

                          final category =
                              categoryProvider.categories[index - 1];

                          final count = taskProvider.tasks
                              .where((task) => task.categoryId == category.id)
                              .length;

                          return CategoryCard(
                            title: category.name,
                            color: category.color,
                            icon: category.icon,
                            taskCount: count,
                            isSelected:
                                taskProvider.selectedCategoryId == category.id,
                            onTap: () {
                              taskProvider.selectCategory(category.id);
                            },
                          );
                        },
                      ),
                    );
                  },
                ),

                const SizedBox(height: 24),

                // Tasks Section Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Tasks", style: AppTextStyles.font18MainInter500),
                    Consumer<TasksProvider>(
                      builder: (context, provider, child) => Text(
                        "${provider.filteredTasks.length} tasks",
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.secondColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Tasks List & Empty State
                Consumer<TasksProvider>(
                  builder: (context, provider, child) {
                    if (provider.isLoading) {
                      return const TasksListShimmer(count: 3);
                    }

                    if (provider.filteredTasks.isEmpty) {
                      return Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          vertical: 40,
                          horizontal: 20,
                        ),
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 64,
                              height: 64,
                              decoration: BoxDecoration(
                                color: AppColors.primaryAccent
                                    .withValues(alpha: 0.1),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.task_alt_rounded,
                                size: 32,
                                color: AppColors.primaryAccent,
                              ),
                            ),
                            const SizedBox(height: 14),
                            const Text(
                              'All caught up!',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: AppColors.mainColor,
                              ),
                            ),
                            const SizedBox(height: 6),
                            const Text(
                              'No tasks found. Enjoy your free time or add a new task ✨',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 13,
                                color: AppColors.secondColor,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: provider.filteredTasks.length,
                      itemBuilder: (context, index) {
                        final task = provider.filteredTasks[index];

                        final category = context
                            .read<CategoriesProvider>()
                            .getCategoryById(task.categoryId);

                        return TaskItem(
                          key: ValueKey(task.id),
                          task: task,
                          category: category,
                        );
                      },
                    );
                  },
                ),

                const SizedBox(height: 90),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
