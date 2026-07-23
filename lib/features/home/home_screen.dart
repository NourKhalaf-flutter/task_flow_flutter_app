import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_flow/core/constants/app_text_styles.dart';
import 'package:task_flow/features/auth/login_provider.dart';
import 'package:task_flow/features/tasks/presentation/provider/tasks_provider.dart';

import '../../core/routes/route_names.dart';
import '../category/presentation/provider/categories_provider.dart';
import '../category/presentation/widgets/category_card.dart';
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
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: .start,
              children: [
                SizedBox(height: 20),
                Consumer<LoginProvider>(
                  builder: (context, provider, child) => provider.isLoading
                      ? CircularProgressIndicator()
                      : Text(
                          "Welcome ${provider.currentUser?.name} ",
                          style: AppTextStyles.font20MainInter500,
                        ),
                ),
                SizedBox(height: 12),
                Text("Categories", style: AppTextStyles.font18MainInter500),

                const SizedBox(height: 12),

                Consumer2<CategoriesProvider, TasksProvider>(
                  builder: (context, categoryProvider, taskProvider, child) {
                    if (categoryProvider.isLoading) {
                      return const CircularProgressIndicator();
                    }

                    return GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),

                      itemCount: categoryProvider.categories.length + 1,

                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio: 1.5,
                          ),

                      itemBuilder: (context, index) {
                        // أول Card هو All
                        if (index == 0) {
                          return CategoryCard(
                            title: 'All',
                            color: Colors.blue.toARGB32(),
                            taskCount: context
                                .read<TasksProvider>()
                                .tasks
                                .length,
                            isSelected: taskProvider.selectedCategoryId == null,
                            onTap: () {
                              taskProvider.selectCategory(null);
                            },
                          );
                        }

                        final category = categoryProvider.categories[index - 1];

                        final count = taskProvider.tasks
                            .where((task) => task.categoryId == category.id)
                            .length;

                        return CategoryCard(
                          title: category.name,
                          color: category.color,

                          taskCount: count,
                          isSelected:
                              taskProvider.selectedCategoryId == category.id,
                          onTap: () {
                            taskProvider.selectCategory(category.id);
                          },
                        );
                      },
                    );
                  },
                ),
                SizedBox(height: 8),
                Consumer<TasksProvider>(
                  builder: (context, provider, child) {
                    if (provider.isLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (provider.tasks.isEmpty) {
                      return const Center(child: Text('No tasks yet'));
                    }
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: provider.filteredTasks.length,
                      itemBuilder: (context, index) {
                        final task = provider.filteredTasks[index];

                        final category = context
                            .read<CategoriesProvider>()
                            .getCategoryById(task.categoryId);

                        return TaskItem(task: task, category: category);
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, RouteNames.addTaskScreen);
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
