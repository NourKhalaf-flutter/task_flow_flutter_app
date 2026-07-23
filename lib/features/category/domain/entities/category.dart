class Category {
  final String id;
  final String name;
  final int color;
  final String? icon;

  Category({
    required this.id,
    required this.name,
    required this.color,
    this.icon,
  });
}