 
import '../../domain/entities/category.dart';

class CategoryModel extends Category {
  CategoryModel({
    required super.id,
    required super.name,
    required super.color,
    super.icon,
  });
  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      id: map['id'],
      name: map['name'],
      color: map['color'],
      icon: map['icon'],
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'id':id,
      'name':name,
      'color':color,
      'icon':icon,
    };
  }
}
