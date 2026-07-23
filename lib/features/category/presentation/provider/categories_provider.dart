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

  List<Category> categories = [];

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
      categories = await getCategoriesUseCase();
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
