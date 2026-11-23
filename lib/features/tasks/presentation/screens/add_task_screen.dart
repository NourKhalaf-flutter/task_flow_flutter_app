import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:task_flow/core/constants/app_colors.dart';
import 'package:task_flow/core/constants/app_text_styles.dart';
import 'package:task_flow/core/widgets/button_widget.dart';
import 'package:task_flow/features/category/presentation/provider/categories_provider.dart';
import 'package:task_flow/features/category/presentation/widgets/category_card.dart';
import 'package:task_flow/features/category/presentation/widgets/create_category_bottom_sheet.dart';
import 'package:task_flow/features/tasks/domain/entities/task.dart';
import 'package:task_flow/features/tasks/presentation/provider/tasks_provider.dart';
import 'package:uuid/uuid.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  Priority _selectedPriority = Priority.medium;
  DateTime? _selectedDueDate = DateTime.now();
  String? _selectedCategoryId;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<CategoriesProvider>().getCategories();
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Widget _buildPriorityCapsule({
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
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.symmetric(vertical: 11),
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
                  fontSize: 13,
                  letterSpacing: 0.1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickDateChip(String label, DateTime targetDate) {
    final isSelected = _selectedDueDate != null &&
        _selectedDueDate!.year == targetDate.year &&
        _selectedDueDate!.month == targetDate.month &&
        _selectedDueDate!.day == targetDate.day;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedDueDate = targetDate;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primaryAccent.withValues(alpha: 0.15)
              : AppColors.cardSurface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? AppColors.primaryAccent
                : Colors.black.withValues(alpha: 0.06),
            width: isSelected ? 1.4 : 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? AppColors.primaryAccent : AppColors.secondColor,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final tomorrow = today.add(const Duration(days: 1));
    final nextWeek = today.add(const Duration(days: 7));

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
          'New Task',
          style: AppTextStyles.font18MainInter500.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title Input
                const Text(
                  'Task Title',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.mainColor,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _titleController,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter task title';
                    }
                    return null;
                  },
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.mainColor,
                  ),
                  decoration: InputDecoration(
                    hintText: 'e.g. Design system onboarding',
                    hintStyle: TextStyle(
                      color: Colors.grey.shade400,
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                    ),
                    filled: true,
                    fillColor: AppColors.cardSurface,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 16,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(
                        color: Colors.black.withValues(alpha: 0.05),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(
                        color: AppColors.primaryAccent,
                        width: 1.5,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Description Input
                const Text(
                  'Description',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.mainColor,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _descriptionController,
                  maxLines: 4,
                  minLines: 3,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.mainColor,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Add details, notes, or links...',
                    hintStyle: TextStyle(
                      color: Colors.grey.shade400,
                      fontSize: 14,
                    ),
                    filled: true,
                    fillColor: AppColors.cardSurface,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 14,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(
                        color: Colors.black.withValues(alpha: 0.05),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(
                        color: AppColors.primaryAccent,
                        width: 1.5,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 22),

                // Priority Selector
                const Text(
                  'Priority',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.mainColor,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    _buildPriorityCapsule(
                      priority: Priority.low,
                      label: 'Low',
                      color: const Color(0xFF3B82F6),
                    ),
                    const SizedBox(width: 10),
                    _buildPriorityCapsule(
                      priority: Priority.medium,
                      label: 'Medium',
                      color: const Color(0xFFF59E0B),
                    ),
                    const SizedBox(width: 10),
                    _buildPriorityCapsule(
                      priority: Priority.high,
                      label: 'High',
                      color: const Color(0xFFEF4444),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Due Date Selector
                const Text(
                  'Due Date',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.mainColor,
                  ),
                ),
                const SizedBox(height: 10),
                InkWell(
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: _selectedDueDate ?? DateTime.now(),
                      firstDate: DateTime.now().subtract(const Duration(days: 365)),
                      lastDate: DateTime(2100),
                      builder: (context, child) {
                        return Theme(
                          data: Theme.of(context).copyWith(
                            colorScheme: const ColorScheme.light(
                              primary: AppColors.primaryAccent,
                              onPrimary: Colors.white,
                              onSurface: AppColors.mainColor,
                            ),
                          ),
                          child: child!,
                        );
                      },
                    );
                    if (picked != null) {
                      setState(() {
                        _selectedDueDate = picked;
                      });
                    }
                  },
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.cardSurface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.black.withValues(alpha: 0.05),
                      ),
                      boxShadow: AppColors.softShadow,
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.primaryAccent.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.calendar_month_rounded,
                            color: AppColors.primaryAccent,
                            size: 18,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            _selectedDueDate == null
                                ? 'Select due date'
                                : DateFormat('EEEE, dd MMM yyyy')
                                    .format(_selectedDueDate!),
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: _selectedDueDate == null
                                  ? Colors.grey.shade400
                                  : AppColors.mainColor,
                            ),
                          ),
                        ),
                        const Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 14,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                // Quick Date Shortcut Chips
                Row(
                  children: [
                    _buildQuickDateChip('Today', today),
                    const SizedBox(width: 8),
                    _buildQuickDateChip('Tomorrow', tomorrow),
                    const SizedBox(width: 8),
                    _buildQuickDateChip('Next Week', nextWeek),
                  ],
                ),

                const SizedBox(height: 24),

                // Category Selector (Visual Horizontal Capsules)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Category',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.mainColor,
                      ),
                    ),
                    if (_selectedCategoryId != null)
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedCategoryId = null;
                          });
                        },
                        child: const Text(
                          'Clear',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.red,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 10),
                Consumer<CategoriesProvider>(
                  builder: (context, catProvider, child) {
                    final categories = catProvider.categories;

                    return SizedBox(
                      height: 48,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        itemCount: categories.length + 1,
                        separatorBuilder: (context, index) =>
                            const SizedBox(width: 10),
                        itemBuilder: (context, index) {
                          // Last item is "+ Add Category"
                          if (index == categories.length) {
                            return InkWell(
                              onTap: () {
                                showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  backgroundColor: Colors.transparent,
                                  builder: (_) =>
                                      const CreateCategoryBottomSheet(),
                                );
                              },
                              borderRadius: BorderRadius.circular(24),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.cardSurface,
                                  borderRadius: BorderRadius.circular(24),
                                  border: Border.all(
                                    color: Colors.black.withValues(alpha: 0.08),
                                    style: BorderStyle.solid,
                                  ),
                                ),
                                child: const Row(
                                  children: [
                                    Icon(
                                      Icons.add_rounded,
                                      size: 16,
                                      color: AppColors.primaryAccent,
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                      'New',
                                      style: TextStyle(
                                        color: AppColors.primaryAccent,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }

                          final category = categories[index];
                          final isSelected = _selectedCategoryId == category.id;
                          final categoryColor = Color(category.color);
                          final icon =
                              CategoryCard.getCategoryIcon(category.name);

                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedCategoryId =
                                    isSelected ? null : category.id;
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
                                    ? categoryColor.withValues(alpha: 0.16)
                                    : AppColors.cardSurface,
                                borderRadius: BorderRadius.circular(24),
                                border: Border.all(
                                  color: isSelected
                                      ? categoryColor
                                      : Colors.black.withValues(alpha: 0.05),
                                  width: isSelected ? 1.6 : 1,
                                ),
                                boxShadow: isSelected
                                    ? [
                                        BoxShadow(
                                          color: categoryColor
                                              .withValues(alpha: 0.25),
                                          blurRadius: 10,
                                          offset: const Offset(0, 3),
                                        ),
                                      ]
                                    : AppColors.softShadow,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 26,
                                    height: 26,
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? categoryColor
                                          : categoryColor
                                              .withValues(alpha: 0.15),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      icon,
                                      size: 14,
                                      color: isSelected
                                          ? Colors.white
                                          : categoryColor,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    category.name,
                                    style: TextStyle(
                                      color: isSelected
                                          ? AppColors.mainColor
                                          : AppColors.secondColor,
                                      fontWeight: isSelected
                                          ? FontWeight.w700
                                          : FontWeight.w600,
                                      fontSize: 13,
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

                const SizedBox(height: 36),

                // Submit Button
                Consumer<TasksProvider>(
                  builder: (context, taskProvider, child) {
                    return ButtonWidget(
                      content: 'CREATE TASK',
                      onPressed: () async {
                        if (!_formKey.currentState!.validate()) {
                          return;
                        }

                        if (_selectedDueDate == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Please select a due date'),
                            ),
                          );
                          return;
                        }

                        final task = Task(
                          id: const Uuid().v4(),
                          title: _titleController.text.trim(),
                          description: _descriptionController.text.trim(),
                          createdAt: DateTime.now(),
                          completedAt: null,
                          status: TaskStatus.todo,
                          priority: _selectedPriority,
                          dueDate: _selectedDueDate!,
                          categoryId: _selectedCategoryId,
                        );

                        await taskProvider.addTask(task);

                        if (!context.mounted) return;

                        if (taskProvider.errorMessage != null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(taskProvider.errorMessage!),
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Task created successfully! 🎉'),
                            ),
                          );
                          Navigator.pop(context);
                        }
                      },
                    );
                  },
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
