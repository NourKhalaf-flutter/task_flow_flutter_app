import '../repositories/categories_repository.dart';

class DeleteCategoryUseCase {
  final CategoriesRepository repository;

  DeleteCategoryUseCase(this.repository);

  Future<void> call(String categoryId) async {
    await repository.deleteCategory(categoryId);
  }
}
