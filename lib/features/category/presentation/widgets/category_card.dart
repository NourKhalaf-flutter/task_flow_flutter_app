import 'package:flutter/material.dart';

class CategoryCard extends StatelessWidget {
  final String title;
  final int color;
  final int taskCount;
  final bool isSelected;
  final VoidCallback onTap;

  const CategoryCard({
    super.key,
    required this.title,
    required this.color,
    required this.taskCount,
    this.isSelected = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color _color = Color(color);

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isSelected
              ? _color.withValues(alpha: 0.25)
              : _color.withValues(alpha: 0.12),

          borderRadius: BorderRadius.circular(18),

          border: Border.all(
            color: isSelected ? _color : _color.withValues(alpha: 0.25),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // color icon
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: Color(color),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.category_outlined,
                color: Colors.white,
                size: 20,
              ),
            ),

            const Spacer(),

            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),

            const SizedBox(height: 4),

            Text(
              '$taskCount Tasks',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}
