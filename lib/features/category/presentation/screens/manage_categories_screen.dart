import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:task_flow/core/constants/app_colors.dart';
import 'package:task_flow/core/widgets/shimmer_loading.dart';
import 'package:task_flow/features/category/domain/entities/category.dart';
import 'package:task_flow/features/category/presentation/provider/categories_provider.dart';
import 'package:task_flow/features/category/presentation/widgets/category_card.dart';
import 'package:task_flow/features/category/presentation/widgets/create_category_bottom_sheet.dart';
import 'package:task_flow/features/tasks/presentation/provider/tasks_provider.dart';

class ManageCategoriesScreen extends StatelessWidget {
  const ManageCategoriesScreen({super.key});

  Future<void> _handleDelete(
    BuildContext context,
    Category category,
    int taskCount,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.red.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.delete_outline_rounded,
                color: AppColors.red,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Delete "${category.name}"?',
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.mainColor,
                ),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (taskCount > 0) ...[
              Text(
                'This category currently contains $taskCount task${taskCount > 1 ? 's' : ''}.',
                style: GoogleFonts.dmSans(
                  fontWeight: FontWeight.w700,
                  color: AppColors.mainColor,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Deleting this category will NOT delete your tasks. All tasks will remain safe in your list, but will become unassigned.',
                style: GoogleFonts.dmSans(
                  color: AppColors.secondColor,
                  fontSize: 13,
                  height: 1.4,
                ),
              ),
            ] else ...[
              Text(
                'Are you sure you want to delete this category? This action cannot be undone.',
                style: GoogleFonts.dmSans(
                  color: AppColors.secondColor,
                  fontSize: 14,
                ),
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(
              'Cancel',
              style: GoogleFonts.dmSans(
                fontWeight: FontWeight.w600,
                color: AppColors.secondColor,
              ),
            ),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(
              taskCount > 0 ? 'Delete & Keep Tasks' : 'Delete',
              style: GoogleFonts.dmSans(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      final scaffoldMessenger = ScaffoldMessenger.of(context);
      // 1. Unassign from tasks first so data integrity is maintained
      if (taskCount > 0) {
        await context.read<TasksProvider>().unassignCategory(category.id);
      }
      // 2. Delete the category
      if (context.mounted) {
        await context.read<CategoriesProvider>().deleteCategory(category.id);
        scaffoldMessenger.showSnackBar(
          SnackBar(
            content: Text('Category "${category.name}" removed.'),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  void _openCreateOrEditSheet(BuildContext context, {Category? categoryToEdit}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => CreateCategoryBottomSheet(categoryToEdit: categoryToEdit),
    );
  }

  @override
  Widget build(BuildContext context) {
    final categoriesProvider = context.watch<CategoriesProvider>();
    final tasksProvider = context.watch<TasksProvider>();
    final allCategories = categoriesProvider.categories;
    final defaultCount = allCategories.where((c) => c.isDefault).length;
    final customCount = allCategories.where((c) => !c.isDefault).length;

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.borderColor),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x06000000),
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: const Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 16,
              color: AppColors.mainColor,
            ),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Manage Categories',
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.mainColor,
            letterSpacing: -0.4,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Categories Overview & Add Action Card
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF4F46E5),
                      Color(0xFF6366F1),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF6366F1).withValues(alpha: 0.18),
                      blurRadius: 14,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Stack(
                    children: [
                      // Subtle Embossed Background Watermark
                      Positioned(
                        right: -15,
                        bottom: -20,
                        child: Transform.rotate(
                          angle: -0.15,
                          child: Icon(
                            Icons.folder_copy_rounded,
                            size: 130,
                            color: Colors.white.withValues(alpha: 0.07),
                          ),
                        ),
                      ),

                      // Card Content
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Title & Breakdown Badge
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Flexible(
                                  child: Text(
                                    '${allCategories.length} Categories',
                                    style: GoogleFonts.inter(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                      letterSpacing: -0.3,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 3.5,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color:
                                          Colors.white.withValues(alpha: 0.2),
                                      width: 0.8,
                                    ),
                                  ),
                                  child: Text(
                                    '$defaultCount Default • $customCount Custom',
                                    style: GoogleFonts.dmSans(
                                      fontSize: 10.5,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white.withValues(alpha: 0.95),
                                      letterSpacing: 0.2,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
                            Text(
                              'Organize your tasks and stay focused.',
                              style: GoogleFonts.dmSans(
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                                color: Colors.white.withValues(alpha: 0.85),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () => _openCreateOrEditSheet(context),
                                borderRadius: BorderRadius.circular(14),
                                child: Container(
                                  width: double.infinity,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 13),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(14),
                                    boxShadow: [
                                      BoxShadow(
                                        color:
                                            Colors.black.withValues(alpha: 0.08),
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        Icons.add_rounded,
                                        color: Color(0xFF4F46E5),
                                        size: 20,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        'Add New Category',
                                        style: GoogleFonts.dmSans(
                                          color: const Color(0xFF4F46E5),
                                          fontWeight: FontWeight.w700,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Categories List or Shimmer Loading
              if (categoriesProvider.isLoading)
                const ManageCategoriesListShimmer()
              else
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: allCategories.length,
                  separatorBuilder: (ctx, i) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final cat = allCategories[index];
                    final catColor = Color(cat.color);
                    final taskCount = tasksProvider.tasks
                        .where((t) => t.categoryId == cat.id)
                        .length;

                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.cardSurface,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: AppColors.borderColor,
                          width: 1,
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x04000000),
                            blurRadius: 8,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          // Category Icon & Color
                          Container(
                            width: 42,
                            height: 42,
                            decoration: BoxDecoration(
                              color: catColor.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Icon(
                              CategoryCard.getCategoryIcon(cat.name, cat.icon),
                              color: catColor,
                              size: 22,
                            ),
                          ),
                          const SizedBox(width: 14),

                          // Title & Task Count
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  cat.name,
                                  style: GoogleFonts.inter(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.mainColor,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '$taskCount ${taskCount == 1 ? 'task' : 'tasks'}',
                                  style: GoogleFonts.dmSans(
                                    fontSize: 12,
                                    color: AppColors.secondColor,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Actions: Default Badge OR Custom (⋮) Menu
                          if (cat.isDefault) ...[
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.greylight,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: AppColors.borderColor,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.lock_outline_rounded,
                                    size: 12,
                                    color: AppColors.secondColor,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Default',
                                    style: GoogleFonts.dmSans(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.secondColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ] else ...[
                            PopupMenuButton<String>(
                              icon: const Icon(
                                Icons.more_vert_rounded,
                                color: AppColors.secondColor,
                                size: 20,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              elevation: 4,
                              onSelected: (value) {
                                if (value == 'edit') {
                                  _openCreateOrEditSheet(
                                    context,
                                    categoryToEdit: cat,
                                  );
                                } else if (value == 'delete') {
                                  _handleDelete(context, cat, taskCount);
                                }
                              },
                              itemBuilder: (context) => [
                                PopupMenuItem(
                                  value: 'edit',
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.edit_outlined,
                                        size: 18,
                                        color: AppColors.mainColor,
                                      ),
                                      const SizedBox(width: 10),
                                      Text(
                                        'Edit',
                                        style: GoogleFonts.dmSans(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.mainColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const PopupMenuDivider(height: 1),
                                PopupMenuItem(
                                  value: 'delete',
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.delete_outline_rounded,
                                        size: 18,
                                        color: AppColors.red,
                                      ),
                                      const SizedBox(width: 10),
                                      Text(
                                        'Delete',
                                        style: GoogleFonts.dmSans(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.red,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    );
                  },
                ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
