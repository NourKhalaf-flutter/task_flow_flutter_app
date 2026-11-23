class Category {
  final String id;
  final String name;
  final int color;
  final String? icon;
  final bool isDefault;

  Category({
    required this.id,
    required this.name,
    required this.color,
    this.icon,
    this.isDefault = false,
  });

  /// Built-in system categories available for all users out of the box
  static final List<Category> defaultCategories = [
    Category(
      id: 'default_work',
      name: 'Work',
      color: 0xFF6366F1, // Electric Indigo
      isDefault: true,
    ),
    Category(
      id: 'default_personal',
      name: 'Personal',
      color: 0xFF10B981, // Mint Emerald
      isDefault: true,
    ),
    Category(
      id: 'default_study',
      name: 'Study',
      color: 0xFFF59E0B, // Warm Amber
      isDefault: true,
    ),
    Category(
      id: 'default_health',
      name: 'Health',
      color: 0xFFEC4899, // Rose Pink
      isDefault: true,
    ),
  ];
}
