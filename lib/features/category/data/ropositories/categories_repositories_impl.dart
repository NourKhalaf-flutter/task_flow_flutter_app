import 'package:task_flow/features/category/domain/entities/category.dart';
import '../../domain/repositories/categories_repository.dart';
import '../datasources/categories_remote_data_source.dart';
import '../model/category_model.dart';

class CategoriesRepositoryImpl implements CategoriesRepository {
  final CategoriesRemoteDataSource remoteDataSource;

  CategoriesRepositoryImpl(this.remoteDataSource);

  @override
  Future<void> addCategory(Category category) async {
    final categoryModel = CategoryModel(
      id: category.id,
      name: category.name,
      color: category.color,
      icon: category.icon,
      isDefault: category.isDefault,
    );

    await remoteDataSource.addCategory(categoryModel);
  }

  @override
  Future<List<Category>> getCategories() async {
    final categoriesModel = await remoteDataSource.getCategories();

    return categoriesModel.map((model) {
      return Category(
        id: model.id,
        name: model.name,
        color: model.color,
        icon: model.icon,
        isDefault: model.isDefault,
      );
    }).toList();
  }

  @override
  Future<void> updateCategory(Category category) async {
    final categoryModel = CategoryModel(
      id: category.id,
      name: category.name,
      color: category.color,
      icon: category.icon,
      isDefault: category.isDefault,
    );

    await remoteDataSource.updateCategory(categoryModel);
  }

  @override
  Future<void> deleteCategory(String categoryId) async {
    await remoteDataSource.deleteCategory(categoryId);
  }
}
