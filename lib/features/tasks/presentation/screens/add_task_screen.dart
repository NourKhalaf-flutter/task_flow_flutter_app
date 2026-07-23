import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_flow/core/constants/app_images.dart';
import 'package:task_flow/features/tasks/presentation/provider/tasks_provider.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/button_secondry_widget.dart';
import '../../../../core/widgets/button_widget.dart';

import '../../../../core/widgets/text_form_field.dart';
import '../../../category/domain/entities/category.dart';
import '../../../category/presentation/provider/categories_provider.dart';
import '../../../category/presentation/widgets/create_category_bottom_sheet.dart';
import '../../domain/entities/task.dart';
import 'package:intl/intl.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  Priority _selectedPriority = Priority.low;
  DateTime? selectedDueDate;
  String? selectedCategoryId;

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<CategoriesProvider>().getCategories();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 40, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Add a new Task',
                    style: AppTextStyles.font32MainInter700,
                  ),

                  const SizedBox(height: 30),

                  TextFormFieldWidget(
                    controller: _titleController,
                    label: 'Task Title',
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter task title';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  TextFormFieldWidget(
                    controller: _descriptionController,
                    label: 'Task Description',
                  ),
                  const SizedBox(height: 20),
                  Wrap(
                    spacing: 8,
                    children: Priority.values.map((priority) {
                      return ChoiceChip(
                        label: Text(priority.name),
                        selected: _selectedPriority == priority,
                        onSelected: (_) {
                          setState(() {
                            _selectedPriority = priority;
                          });
                        },
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 20),
                  InkWell(
                    onTap: () async {
                      final pickedDate = await showDatePicker(
                        context: context,
                        initialDate: selectedDueDate ?? DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2100),
                      );

                      if (pickedDate != null) {
                        setState(() {
                          selectedDueDate = pickedDate;
                        });
                      }
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.calendar_today_outlined),
                          const SizedBox(width: 12),

                          Expanded(
                            child: Text(
                              selectedDueDate == null
                                  ? 'Select due date'
                                  : DateFormat(
                                      'dd MMM yyyy',
                                    ).format(selectedDueDate!),
                              style: AppTextStyles.font14SecondSans,
                            ),
                          ),

                          const Icon(Icons.arrow_forward_ios, size: 16),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Divider(),
                  const SizedBox(height: 10),
                  Text('Task Category', style: AppTextStyles.font14MainSans600),

                  Container(
                    margin: const EdgeInsets.only(top: 12),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Consumer<CategoriesProvider>(
                      builder: (context, provider, child) => provider.isLoading
                          ? CircularProgressIndicator()
                          : DropdownButtonFormField<String>(
                              initialValue: selectedCategoryId,
                              hint: const Text('Select category'),

                              style: AppTextStyles.font16SecondSans,

                              decoration: InputDecoration(
                                border: InputBorder.none,
                              ),
                              items: provider.categories.map((category) {
                                return DropdownMenuItem(
                                  value: category.id,
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 12,
                                        height: 12,
                                        decoration: BoxDecoration(
                                          color: Color(category.color),
                                          shape: BoxShape.circle,
                                        ),
                                      ),

                                      const SizedBox(width: 8),
                                      Text(category.name),
                                    ],
                                  ),
                                );
                              }).toList(),

                              onChanged: (value) {
                                setState(() {
                                  selectedCategoryId = value;
                                });
                              },
                            ),
                    ),
                  ),
                  SizedBox(height: 10),
                  TextButton(
                    child: Text('+ Add new category'),
                    onPressed: () {
                      showCreateCategorySheet(context);
                    },
                  ),
                  SizedBox(height: 20),

                  Consumer<TasksProvider>(
                    builder:
                        (BuildContext context, authProvider, Widget? child) {
                          return authProvider.isLoading
                              ? const Center(child: CircularProgressIndicator())
                              : ButtonWidget(
                                  content: 'ADD TASK',
                                  onPressed: () async {
                                    if (!_formKey.currentState!.validate()) {
                                      return;
                                    }

                                    if (selectedDueDate == null) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            "Please select due date",
                                          ),
                                          duration: const Duration(seconds: 6),
                                        ),
                                      );
                                    } else {
                                      final task = Task(
                                        id: const Uuid().v4(),
                                        title: _titleController.text.trim(),
                                        description: _descriptionController.text
                                            .trim(),
                                        createdAt: DateTime.now(),
                                        completedAt: null,
                                        status: TaskStatus.todo,
                                        priority: _selectedPriority,
                                        dueDate: selectedDueDate!,
                                        categoryId: selectedCategoryId,
                                      );

                                      await context
                                          .read<TasksProvider>()
                                          .addTask(task);
                                    }

                                    if (authProvider.errorMessage != null) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            authProvider.errorMessage!,
                                          ),
                                          duration: const Duration(seconds: 6),
                                        ),
                                      );
                                    } else {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            "Task added successfully",
                                          ),
                                          duration: const Duration(seconds: 6),
                                        ),
                                      );

                                      if (context.mounted) {
                                        Navigator.pop(context);
                                      }
                                    }
                                  },
                                );
                        },
                  ),
                  const SizedBox(height: 20),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

void showCreateCategorySheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,

    builder: (context) {
      return CreateCategoryBottomSheet();
    },
  );
}
