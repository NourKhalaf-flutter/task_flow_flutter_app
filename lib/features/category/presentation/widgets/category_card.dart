import 'package:flutter/material.dart';
import 'package:task_flow/core/constants/app_colors.dart';

class CategoryIconOption {
  final String key;
  final String label;
  final IconData icon;

  const CategoryIconOption({
    required this.key,
    required this.label,
    required this.icon,
  });
}

class CategoryCard extends StatelessWidget {
  final String title;
  final int color;
  final int taskCount;
  final bool isSelected;
  final VoidCallback onTap;
  final String? icon;

  const CategoryCard({
    super.key,
    required this.title,
    required this.color,
    required this.taskCount,
    this.isSelected = false,
    required this.onTap,
    this.icon,
  });

  /// Available selectable category icons with short Firebase identifier keys
  static const List<CategoryIconOption> availableIcons = [
    CategoryIconOption(key: 'folder', label: 'General', icon: Icons.folder_rounded),
    CategoryIconOption(key: 'work', label: 'Work', icon: Icons.business_center_rounded),
    CategoryIconOption(key: 'person', label: 'Personal', icon: Icons.person_rounded),
    CategoryIconOption(key: 'study', label: 'Study', icon: Icons.menu_book_rounded),
    CategoryIconOption(key: 'health', label: 'Health', icon: Icons.favorite_rounded),
    CategoryIconOption(key: 'shopping', label: 'Shopping', icon: Icons.shopping_bag_rounded),
    CategoryIconOption(key: 'finance', label: 'Finance', icon: Icons.account_balance_wallet_rounded),
    CategoryIconOption(key: 'home', label: 'Home', icon: Icons.home_rounded),
    CategoryIconOption(key: 'design', label: 'Design', icon: Icons.palette_rounded),
    CategoryIconOption(key: 'code', label: 'Code', icon: Icons.code_rounded),
    CategoryIconOption(key: 'meeting', label: 'Meeting', icon: Icons.phone_in_talk_rounded),
  ];

  /// Resolves icon by key first, then falls back to category name matching
  static IconData getCategoryIcon([String? title, String? iconKey]) {
    if (iconKey != null && iconKey.trim().isNotEmpty) {
      final normalized = iconKey.toLowerCase().trim();
      for (final option in availableIcons) {
        if (option.key == normalized) {
          return option.icon;
        }
      }
      // Common aliases
      if (normalized == 'personal') return Icons.person_rounded;
      if (normalized == 'call') return Icons.phone_in_talk_rounded;
      if (normalized == 'cart') return Icons.shopping_bag_rounded;
      if (normalized == 'money') return Icons.account_balance_wallet_rounded;
      if (normalized == 'fitness') return Icons.favorite_rounded;
    }

    if (title != null && title.trim().isNotEmpty) {
      return _getCategoryIconByName(title);
    }

    return Icons.folder_rounded;
  }

  /// Semantic Icon Resolver fallback based on category name
  static IconData _getCategoryIconByName(String title) {
    final lower = title.toLowerCase().trim();
    if (lower == 'all' || lower == 'الكل') {
      return Icons.grid_view_rounded;
    } else if (lower.contains('work') ||
        lower.contains('عمل') ||
        lower.contains('job') ||
        lower.contains('office') ||
        lower.contains('business')) {
      return Icons.business_center_rounded;
    } else if (lower.contains('study') ||
        lower.contains('دراسة') ||
        lower.contains('learn') ||
        lower.contains('school') ||
        lower.contains('read') ||
        lower.contains('book')) {
      return Icons.menu_book_rounded;
    } else if (lower.contains('health') ||
        lower.contains('صحة') ||
        lower.contains('fitness') ||
        lower.contains('gym') ||
        lower.contains('workout') ||
        lower.contains('sport')) {
      return Icons.favorite_rounded;
    } else if (lower.contains('personal') ||
        lower.contains('شخصي') ||
        lower.contains('life') ||
        lower.contains('self')) {
      return Icons.person_rounded;
    } else if (lower.contains('shop') ||
        lower.contains('تسوق') ||
        lower.contains('buy') ||
        lower.contains('cart') ||
        lower.contains('market')) {
      return Icons.shopping_bag_rounded;
    } else if (lower.contains('money') ||
        lower.contains('مال') ||
        lower.contains('finance') ||
        lower.contains('bank') ||
        lower.contains('budget')) {
      return Icons.account_balance_wallet_rounded;
    } else if (lower.contains('home') ||
        lower.contains('منزل') ||
        lower.contains('بيت') ||
        lower.contains('family')) {
      return Icons.home_rounded;
    } else if (lower.contains('design') ||
        lower.contains('تصميم') ||
        lower.contains('art')) {
      return Icons.palette_rounded;
    } else if (lower.contains('code') ||
        lower.contains('برمجة') ||
        lower.contains('dev') ||
        lower.contains('tech')) {
      return Icons.code_rounded;
    } else if (lower.contains('call') ||
        lower.contains('اتصال') ||
        lower.contains('meeting')) {
      return Icons.phone_in_talk_rounded;
    }
    return Icons.folder_rounded;
  }

  @override
  Widget build(BuildContext context) {
    final Color categoryColor = Color(color);
    final IconData iconData = getCategoryIcon(title, icon);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
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
                    color: categoryColor.withValues(alpha: 0.25),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : AppColors.softShadow,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Semantic Icon Circle
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: isSelected
                    ? categoryColor
                    : categoryColor.withValues(alpha: 0.16),
                shape: BoxShape.circle,
              ),
              child: Icon(
                iconData,
                color: isSelected ? Colors.white : categoryColor,
                size: 15,
              ),
            ),
            const SizedBox(width: 8),
            // Title
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                color: isSelected ? AppColors.mainColor : AppColors.secondColor,
                letterSpacing: 0.1,
              ),
            ),
            const SizedBox(width: 8),
            // Task count badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
              decoration: BoxDecoration(
                color: isSelected
                    ? categoryColor.withValues(alpha: 0.25)
                    : AppColors.greylight,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '$taskCount',
                style: TextStyle(
                  color: isSelected ? categoryColor : AppColors.secondColor,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
