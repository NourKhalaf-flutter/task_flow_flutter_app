 
import '../entities/category.dart';

abstract class CategoriesRepository {

  Future<void> addCategory(Category category);

  Future<List<Category>> getCategories();

  // Future<void> updateCategory(Category category);

  // Future<void> deleteCategory(String categoryId);

}