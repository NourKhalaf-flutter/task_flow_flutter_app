import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/widgets/text_form_field.dart';
import '../../domain/entities/category.dart';
import '../provider/categories_provider.dart';

class CreateCategoryBottomSheet extends StatefulWidget {
  const CreateCategoryBottomSheet({super.key});

  @override
  State<CreateCategoryBottomSheet> createState() =>
      _CreateCategoryBottomSheetState();
}

class _CreateCategoryBottomSheetState extends State<CreateCategoryBottomSheet> {
  final _controller = TextEditingController();

  Color _selectedColor = const Color(0xff4A90E2);

  final List<Color> _categoryColors = const [
    Color(0xFF5B8DEF),
    Color(0xFF4ECDC4),
    Color(0xFFFFC857),
    Color(0xFF9B72CF),
    Color(0xFFFF7B7B),
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        24,
        16,
        24,
        MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 45,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),

            const SizedBox(height: 20),

            const Center(
              child: Text(
                'Create Category',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),

            const SizedBox(height: 30),

            const Text(
              'Category Name',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 10),

            TextFormFieldWidget(
              controller: _controller,
              label: 'Category Name',
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter category name';
                }
                return null;
              },
            ),

            const SizedBox(height: 28),

            const Text(
              'Choose Color',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 16),

            Wrap(
              spacing: 14,
              runSpacing: 14,
              children: _categoryColors.map((color) {
                final isSelected = color == _selectedColor;

                return InkWell(
                  borderRadius: BorderRadius.circular(30),
                  onTap: () {
                    setState(() {
                      _selectedColor = color;
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    width: isSelected ? 48 : 42,
                    height: isSelected ? 48 : 42,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected ? Colors.black : Colors.transparent,
                        width: 2.5,
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: color.withValues(alpha: 0.35),
                                blurRadius: 10,
                                spreadRadius: 2,
                              ),
                            ]
                          : [],
                    ),
                    child: isSelected
                        ? const Icon(Icons.check, color: Colors.white, size: 20)
                        : null,
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 36),

            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () {
                  final name = _controller.text.trim();

                  if (name.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please enter category name'),
                      ),
                    );
                    return;
                  }

                  context.read<CategoriesProvider>().addCategory(
                    Category(
                      id: Uuid().v4(),
                      name: name,
                      color: _selectedColor.toARGB32(),
                    ),
                  );

                  Navigator.pop(context);
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 14),
                  child: Text('Create Category'),
                ),
              ),
            ),

            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
