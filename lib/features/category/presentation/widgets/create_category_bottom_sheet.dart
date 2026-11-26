import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:task_flow/core/constants/app_colors.dart';
import 'package:task_flow/core/widgets/button_widget.dart';
import 'package:task_flow/core/widgets/text_form_field.dart';
import 'package:task_flow/features/category/domain/entities/category.dart';
import 'package:task_flow/features/category/presentation/provider/categories_provider.dart';
import 'package:task_flow/features/category/presentation/widgets/category_card.dart';

class CreateCategoryBottomSheet extends StatefulWidget {
  final Category? categoryToEdit;

  const CreateCategoryBottomSheet({super.key, this.categoryToEdit});

  @override
  State<CreateCategoryBottomSheet> createState() =>
      _CreateCategoryBottomSheetState();
}

class _CreateCategoryBottomSheetState extends State<CreateCategoryBottomSheet> {
  late final TextEditingController _controller;
  final _formKey = GlobalKey<FormState>();

  late Color _selectedColor;
  late String _selectedIconKey;

  bool get isEditing => widget.categoryToEdit != null;

  final List<Color> _categoryColors = const [
    Color(0xFF6366F1), // Indigo
    Color(0xFF10B981), // Emerald
    Color(0xFFF59E0B), // Amber
    Color(0xFF8B5CF6), // Violet
    Color(0xFFEF4444), // Crimson
    Color(0xFF0EA5E9), // Sky Blue
    Color(0xFFEC4899), // Pink
    Color(0xFF14B8A6), // Teal
  ];

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.categoryToEdit?.name ?? '');
    _selectedColor = widget.categoryToEdit != null
        ? Color(widget.categoryToEdit!.color)
        : const Color(0xFF6366F1);
    _selectedIconKey = widget.categoryToEdit?.icon ?? 'folder';
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        boxShadow: [
          BoxShadow(
            color: Color(0x1A000000),
            blurRadius: 30,
            offset: Offset(0, -6),
          ),
        ],
      ),
      padding: EdgeInsets.fromLTRB(
        24,
        16,
        24,
        MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Drag handle
                Center(
                  child: Container(
                    width: 44,
                    height: 5,
                    decoration: BoxDecoration(
                      color: AppColors.borderColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Header with title and close button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: _selectedColor.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            CategoryCard.getCategoryIcon(null, _selectedIconKey),
                            color: _selectedColor,
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          isEditing ? 'Edit Category' : 'New Category',
                          style: GoogleFonts.inter(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: AppColors.mainColor,
                            letterSpacing: -0.4,
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: Container(
                        width: 32,
                        height: 32,
                        decoration: const BoxDecoration(
                          color: AppColors.greylight,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.close_rounded,
                          size: 18,
                          color: AppColors.secondColor,
                        ),
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Category Name Field
                Text(
                  'CATEGORY NAME',
                  style: GoogleFonts.dmSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.secondColor,
                    letterSpacing: 0.6,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormFieldWidget(
                  controller: _controller,
                  label: 'Category Name',
                  hintText: 'e.g. Design, Finance, Workout',
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  prefixIcon: const Icon(
                    Icons.label_outline_rounded,
                    size: 20,
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter category name';
                    }

                    final trimmedInput = value.trim().toLowerCase();
                    final allCategories =
                        context.read<CategoriesProvider>().categories;

                    final isDuplicate = allCategories.any((cat) {
                      // When editing, ignore self comparison
                      if (isEditing && cat.id == widget.categoryToEdit!.id) {
                        return false;
                      }
                      return cat.name.trim().toLowerCase() == trimmedInput;
                    });

                    if (isDuplicate) {
                      return 'This category already exists. Please choose a different name.';
                    }

                    return null;
                  },
                ),
                const SizedBox(height: 24),

                // Icon Selection
                Text(
                  'CHOOSE ICON',
                  style: GoogleFonts.dmSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.secondColor,
                    letterSpacing: 0.6,
                  ),
                ),
                const SizedBox(height: 12),

                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: CategoryCard.availableIcons.map((option) {
                    final isSelected = option.key == _selectedIconKey;

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedIconKey = option.key;
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? _selectedColor
                              : AppColors.greylight,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: isSelected
                                ? _selectedColor
                                : AppColors.borderColor,
                            width: isSelected ? 1.5 : 1,
                          ),
                          
                        ),
                        child: Icon(
                          option.icon,
                          color: isSelected ? Colors.white : AppColors.secondColor,
                          size: 20,
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 24),

                // Color Selection
                Text(
                  'CHOOSE ACCENT COLOR',
                  style: GoogleFonts.dmSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.secondColor,
                    letterSpacing: 0.6,
                  ),
                ),
                const SizedBox(height: 14),

                Wrap(
                  spacing: 14,
                  runSpacing: 14,
                  children: _categoryColors.map((color) {
                    final isSelected = color == _selectedColor;

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedColor = color;
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isSelected ? Colors.white : Colors.transparent,
                            width: 3,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: isSelected
                                  ? color.withValues(alpha: 0.45)
                                  : color.withValues(alpha: 0.15),
                              blurRadius: isSelected ? 12 : 6,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: isSelected
                            ? const Icon(
                                Icons.check_rounded,
                                color: Colors.white,
                                size: 22,
                              )
                            : null,
                      ),
                    );
                  }).toList(),
                ),

                const SizedBox(height: 32),

                // Submit Button
                ButtonWidget(
                  content: isEditing ? 'Save Changes' : 'Create Category',
                  onPressed: () {
                    if (!_formKey.currentState!.validate()) {
                      return;
                    }

                    final name = _controller.text.trim();

                    if (isEditing) {
                      context.read<CategoriesProvider>().updateCategory(
                            Category(
                              id: widget.categoryToEdit!.id,
                              name: name,
                              color: _selectedColor.toARGB32(),
                              icon: _selectedIconKey,
                              isDefault: widget.categoryToEdit!.isDefault,
                            ),
                          );
                    } else {
                      context.read<CategoriesProvider>().addCategory(
                            Category(
                              id: const Uuid().v4(),
                              name: name,
                              color: _selectedColor.toARGB32(),
                              icon: _selectedIconKey,
                            ),
                          );
                    }

                    Navigator.pop(context);
                  },
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
