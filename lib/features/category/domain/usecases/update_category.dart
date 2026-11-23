import '../entities/category.dart';
import '../repositories/categories_repository.dart';

class UpdateCategoryUseCase {
  final CategoriesRepository repository;

  UpdateCategoryUseCase(this.repository);

  Future<void> call(Category category) async {
    await repository.updateCategory(category);
  }
}
