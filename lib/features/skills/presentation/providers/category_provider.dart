import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:skill_swap_marketplace/core/constants/firestore_constants.dart';
import 'package:skill_swap_marketplace/features/skills/domain/models/category_model.dart';

part 'category_provider.g.dart';

/// Provider for fetching all categories
@riverpod
Future<List<Category>> categories(CategoriesRef ref) async {
  final firestore = FirebaseFirestore.instance;
  final snapshot = await firestore
      .collection(FirestoreCollections.categories)
      .orderBy(CategoryFields.order)
      .get();

  return snapshot.docs.map((doc) => Category.fromJson(doc.data())).toList();
}

/// Provider for fetching a single category by ID
@riverpod
Future<Category?> categoryById(CategoryByIdRef ref, String categoryId) async {
  final firestore = FirebaseFirestore.instance;
  final doc = await firestore
      .collection(FirestoreCollections.categories)
      .doc(categoryId)
      .get();

  if (!doc.exists || doc.data() == null) {
    return null;
  }

  return Category.fromJson(doc.data()!);
}