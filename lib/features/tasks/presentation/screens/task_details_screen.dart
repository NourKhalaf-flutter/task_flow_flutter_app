import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:task_flow/core/constants/app_colors.dart';
import 'package:task_flow/core/constants/app_text_styles.dart';
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
  bool _isEditing = false;

  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late Priority _selectedPriority;
  late DateTime _selectedDueDate;
  String? _selectedCategoryId;

  @override
  void initState() {
    super.initState();
    _currentTask = widget.task;
    _titleController = TextEditingController(text: _currentTask.title);
    _descriptionController =
        TextEditingController(text: _currentTask.description);
    _selectedPriority = _currentTask.priority;
    _selectedDueDate = _currentTask.dueDate;
    _selectedCategoryId = _currentTask.categoryId;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
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

  Widget _buildPrioritySelector() {
    return Row(
      children: [
        _buildPriorityEditCapsule(
          priority: Priority.low,
          label: 'Low',
          color: const Color(0xFF3B82F6),
        ),
        const SizedBox(width: 10),
        _buildPriorityEditCapsule(
          priority: Priority.medium,
          label: 'Medium',
          color: const Color(0xFFF59E0B),
        ),
        const SizedBox(width: 10),
        _buildPriorityEditCapsule(
          priority: Priority.high,
          label: 'High',
          color: const Color(0xFFEF4444),
        ),
      ],
    );
  }

  Widget _buildPriorityEditCapsule({
    required Priority priority,
    required String label,
    required Color color,
  }) {
    final isSelected = _selectedPriority == priority;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedPriority = priority;
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected
                ? color.withValues(alpha: 0.14)
                : AppColors.cardSurface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isSelected
                  ? color
                  : Colors.black.withValues(alpha: 0.06),
              width: isSelected ? 1.6 : 1,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: color.withValues(alpha: 0.22),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : AppColors.softShadow,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 7,
                height: 7,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 7),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? AppColors.mainColor : AppColors.secondColor,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _saveChanges() async {
    final title = _titleController.text.trim();
    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Title cannot be empty')),
      );
      return;
    }

    final updated = _currentTask.copyWith(
      title: title,
      description: _descriptionController.text.trim(),
      priority: _selectedPriority,
      dueDate: _selectedDueDate,
      categoryId: _selectedCategoryId,
    );

    await context.read<TasksProvider>().updateTask(updated);

    setState(() {
      _currentTask = updated;
      _isEditing = false;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Task updated successfully! ✨')),
      );
    }
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
        .getCategoryById(_isEditing ? _selectedCategoryId : _currentTask.categoryId);

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
          _isEditing ? 'Edit Task' : 'Task Details',
          style: AppTextStyles.font18MainInter500.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              _isEditing ? Icons.check_circle_rounded : Icons.edit_outlined,
              color: _isEditing ? AppColors.mintAccent : AppColors.mainColor,
            ),
            onPressed: () {
              if (_isEditing) {
                _saveChanges();
              } else {
                setState(() {
                  _isEditing = true;
                });
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline_rounded, color: AppColors.red),
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
              // Status Indicator Banner
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: isCompleted
                      ? AppColors.mintAccent.withValues(alpha: 0.12)
                      : AppColors.primaryAccent.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isCompleted
                        ? AppColors.mintAccent.withValues(alpha: 0.3)
                        : AppColors.primaryAccent.withValues(alpha: 0.25),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      isCompleted
                          ? Icons.check_circle_rounded
                          : Icons.access_time_rounded,
                      color: isCompleted
                          ? AppColors.mintAccent
                          : AppColors.primaryAccent,
                      size: 20,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        isCompleted ? 'Completed Task 🎉' : 'In Progress / To-Do',
                        style: TextStyle(
                          color: isCompleted
                              ? AppColors.mintAccent
                              : AppColors.primaryAccent,
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                        visualDensity: VisualDensity.compact,
                        padding: EdgeInsets.zero,
                      ),
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
                      child: Text(
                        isCompleted ? 'Mark Active' : 'Mark Done',
                        style: TextStyle(
                          color: isCompleted
                              ? AppColors.secondColor
                              : AppColors.primaryAccent,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Title Section
              const Text(
                'TITLE',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.secondColor,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 8),
              if (_isEditing)
                TextFormField(
                  controller: _titleController,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.mainColor,
                  ),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppColors.cardSurface,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: AppColors.borderColor),
                    ),
                  ),
                )
              else
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.cardSurface,
                    borderRadius: BorderRadius.circular(16),
                    border: AppColors.subtleCardBorder,
                    boxShadow: AppColors.softShadow,
                  ),
                  child: Text(
                    _currentTask.title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isCompleted
                          ? AppColors.secondColor.withValues(alpha: 0.6)
                          : AppColors.mainColor,
                      decoration:
                          isCompleted ? TextDecoration.lineThrough : null,
                    ),
                  ),
                ),

              const SizedBox(height: 20),

              // Description Section
              const Text(
                'DESCRIPTION',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.secondColor,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 8),
              if (_isEditing)
                TextFormField(
                  controller: _descriptionController,
                  maxLines: 4,
                  minLines: 3,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.mainColor,
                  ),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppColors.cardSurface,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: AppColors.borderColor),
                    ),
                  ),
                )
              else
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.cardSurface,
                    borderRadius: BorderRadius.circular(16),
                    border: AppColors.subtleCardBorder,
                    boxShadow: AppColors.softShadow,
                  ),
                  child: Text(
                    _currentTask.description.isNotEmpty
                        ? _currentTask.description
                        : 'No description provided.',
                    style: TextStyle(
                      fontSize: 14,
                      color: _currentTask.description.isNotEmpty
                          ? AppColors.secondColor
                          : Colors.grey.shade400,
                      height: 1.5,
                    ),
                  ),
                ),

              const SizedBox(height: 22),

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
                          _buildPriorityBadge(_isEditing
                              ? _selectedPriority
                              : _currentTask.priority),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Due Date
                  Expanded(
                    child: InkWell(
                      onTap: _isEditing
                          ? () async {
                              final picked = await showDatePicker(
                                context: context,
                                initialDate: _selectedDueDate,
                                firstDate: DateTime.now()
                                    .subtract(const Duration(days: 365)),
                                lastDate: DateTime(2100),
                              );
                              if (picked != null) {
                                setState(() {
                                  _selectedDueDate = picked;
                                });
                              }
                            }
                          : null,
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: AppColors.cardSurface,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: _isEditing
                                ? AppColors.primaryAccent
                                : Colors.black.withValues(alpha: 0.04),
                            width: _isEditing ? 1.5 : 1,
                          ),
                          boxShadow: AppColors.softShadow,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Due Date',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.secondColor,
                                  ),
                                ),
                                if (_isEditing)
                                  const Icon(
                                    Icons.edit_calendar_rounded,
                                    size: 14,
                                    color: AppColors.primaryAccent,
                                  ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              DateFormat('dd MMM yyyy').format(_isEditing
                                  ? _selectedDueDate
                                  : _currentTask.dueDate),
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
                  ),
                ],
              ),

              if (_isEditing) ...[
                const SizedBox(height: 16),
                _buildPrioritySelector(),
              ],

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

              if (!_isEditing) ...[
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
                            CategoryCard.getCategoryIcon(category.name),
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
              ] else ...[
                // Category Picker (In Edit Mode)
                Consumer<CategoriesProvider>(
                  builder: (context, catProvider, child) {
                    final categories = catProvider.categories;

                    return SizedBox(
                      height: 48,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        itemCount: categories.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(width: 8),
                        itemBuilder: (context, index) {
                          final cat = categories[index];
                          final isSelected = _selectedCategoryId == cat.id;
                          final color = Color(cat.color);

                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedCategoryId =
                                    isSelected ? null : cat.id;
                              });
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? color.withValues(alpha: 0.18)
                                    : AppColors.cardSurface,
                                borderRadius: BorderRadius.circular(24),
                                border: Border.all(
                                  color: isSelected
                                      ? color
                                      : Colors.black.withValues(alpha: 0.06),
                                  width: isSelected ? 1.6 : 1,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    CategoryCard.getCategoryIcon(cat.name),
                                    size: 14,
                                    color: color,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    cat.name,
                                    style: TextStyle(
                                      color: isSelected
                                          ? AppColors.mainColor
                                          : AppColors.secondColor,
                                      fontWeight: isSelected
                                          ? FontWeight.bold
                                          : FontWeight.w500,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ],

              const SizedBox(height: 36),

              // Bottom Action Button
              if (_isEditing)
                ButtonWidget(
                  content: 'SAVE CHANGES',
                  onPressed: _saveChanges,
                )
              else
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
