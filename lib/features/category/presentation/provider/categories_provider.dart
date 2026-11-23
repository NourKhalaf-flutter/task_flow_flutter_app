import 'package:flutter/material.dart';
import 'package:task_flow/features/category/domain/usecases/add_category.dart';

import '../../domain/entities/category.dart';
import '../../domain/usecases/get_categories.dart';

class CategoriesProvider extends ChangeNotifier {
  final AddCategoryUseCase addCategoryUseCase;
  final GetCategoriesUseCase getCategoriesUseCase;

  CategoriesProvider({
    required this.addCategoryUseCase,
    required this.getCategoriesUseCase,
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
