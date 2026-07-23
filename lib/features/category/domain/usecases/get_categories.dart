 import '../entities/category.dart';
import '../repositories/categories_repository.dart';

class GetCategoriesUseCase {
  final CategoriesRepository repository;

  GetCategoriesUseCase(this.repository);

  Future<List<Category>> call( )   {
    return   repository.getCategories();
  }
}