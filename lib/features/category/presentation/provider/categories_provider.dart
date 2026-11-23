import 'package:flutter/material.dart';
import '../../domain/entities/category.dart';
import '../../domain/usecases/add_category.dart';
import '../../domain/usecases/delete_category.dart';
import '../../domain/usecases/get_categories.dart';
import '../../domain/usecases/update_category.dart';

class CategoriesProvider extends ChangeNotifier {
  final AddCategoryUseCase addCategoryUseCase;
  final GetCategoriesUseCase getCategoriesUseCase;
  final UpdateCategoryUseCase updateCategoryUseCase;
  final DeleteCategoryUseCase deleteCategoryUseCase;

  CategoriesProvider({
    required this.addCategoryUseCase,
    required this.getCategoriesUseCase,
    required this.updateCategoryUseCase,
    required this.deleteCategoryUseCase,
  });

  bool isLoading = false;
  String? errorMessage;

  List<Category> _customCategories = [];

  /// Returns system default categories + user custom categories
  List<Category> get categories => [
        ...Category.defaultCategories,
        ..._customCategories,
      ];

  Future<void> addCategory(Category category) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      await addCategoryUseCase(category);
      await getCategories();
    } catch (e) {
      errorMessage = e.toString();
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> updateCategory(Category category) async {
    final index = _customCategories.indexWhere((c) => c.id == category.id);
    if (index != -1) {
      final old = _customCategories[index];
      // Optimistic update
      _customCategories[index] = category;
      notifyListeners();

      try {
        await updateCategoryUseCase(category);
      } catch (e) {
        _customCategories[index] = old;
        errorMessage = e.toString();
        notifyListeners();
      }
    }
  }

  Future<void> deleteCategory(String categoryId) async {
    final index = _customCategories.indexWhere((c) => c.id == categoryId);
    if (index == -1) return;

    final removed = _customCategories.removeAt(index);
    notifyListeners();

    try {
      await deleteCategoryUseCase(categoryId);
    } catch (e) {
      _customCategories.insert(index, removed);
      errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<void> getCategories() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final fetched = await getCategoriesUseCase();
      // Filter out any if user previously saved duplicates of defaults
      _customCategories = fetched
          .where((cat) => !Category.defaultCategories.any((d) => d.id == cat.id))
          .toList();
    } catch (e) {
      errorMessage = e.toString();
    }

    isLoading = false;
    notifyListeners();
  }

  Category? getCategoryById(String? id) {
    if (id == null) return null;

    try {
      return categories.firstWhere((c) => c.id == id);
    } catch (_) {
      return null;
    }
  }
}
