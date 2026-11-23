import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../model/category_model.dart';

abstract class CategoriesRemoteDataSource {
  Future<void> addCategory(CategoryModel category);
  Future<List<CategoryModel>> getCategories();
  Future<void> updateCategory(CategoryModel category);
  Future<void> deleteCategory(String categoryId);
}

class CategoriesRemoteDataSourceImpl implements CategoriesRemoteDataSource {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  CategoriesRemoteDataSourceImpl({required this.firestore, required this.auth});

  @override
  Future<void> addCategory(CategoryModel category) async {
    final user = auth.currentUser;
    if (user == null) {
      throw Exception('User is not logged in.');
    }

    await firestore
        .collection('users')
        .doc(user.uid)
        .collection('categories')
        .doc(category.id)
        .set(category.toMap());
  }

  @override
  Future<List<CategoryModel>> getCategories() async {
    final user = auth.currentUser;
    if (user == null) {
      throw Exception('User is not logged in.');
    }
    final snapshot = await firestore
        .collection('users')
        .doc(user.uid)
        .collection('categories')
        .get();

    return snapshot.docs.map((doc) {
      return CategoryModel.fromMap(doc.data());
    }).toList();
  }

  @override
  Future<void> updateCategory(CategoryModel category) async {
    final user = auth.currentUser;
    if (user == null) {
      throw Exception('User is not logged in.');
    }

    await firestore
        .collection('users')
        .doc(user.uid)
        .collection('categories')
        .doc(category.id)
        .update(category.toMap());
  }

  @override
  Future<void> deleteCategory(String categoryId) async {
    final user = auth.currentUser;
    if (user == null) {
      throw Exception('User is not logged in.');
    }

    await firestore
        .collection('users')
        .doc(user.uid)
        .collection('categories')
        .doc(categoryId)
        .delete();
  }
}
