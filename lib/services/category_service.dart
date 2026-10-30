import 'package:flutter/foundation.dart';

import '../models/category_model.dart';

class CategoryService {
  CategoryService._();

  // Satu sumber data kategori untuk seluruh aplikasi.
  // Kategori "All" hanya untuk filter, bukan kategori toko.
  static final ValueNotifier<List<CategoryModel>> categories =
      ValueNotifier<List<CategoryModel>>(
    CategoryModel.samples
        .where(
          (category) =>
              category.name.toLowerCase() != 'all',
        )
        .toList(),
  );

  // Mengambil semua kategori.
  static List<CategoryModel> getAllCategories() {
    return List<CategoryModel>.unmodifiable(categories.value);
  }

  // Mencari kategori berdasarkan ID.
  static CategoryModel? getCategoryById(String id) {
    for (final category in categories.value) {
      if (category.id == id) {
        return category;
      }
    }

    return null;
  }

  // Mengecek apakah nama kategori sudah tersedia.
  static bool categoryExists(String name) {
    final normalizedName = name.trim().toLowerCase();

    return categories.value.any(
      (category) =>
          category.name.trim().toLowerCase() == normalizedName,
    );
  }

  // Menambahkan kategori baru.
  static bool addCategory(CategoryModel category) {
    final name = category.name.trim();

    if (name.isEmpty || categoryExists(name)) {
      return false;
    }

    final updated = List<CategoryModel>.from(categories.value);

    updated.add(
      CategoryModel(
        id: category.id,
        name: name,
        image: category.image,
        icon: category.icon,
      ),
    );

    categories.value = updated;
    return true;
  }

  // Menghapus kategori berdasarkan ID.
  static bool deleteCategory(String id) {
    final updated = List<CategoryModel>.from(categories.value);

    final originalLength = updated.length;

    updated.removeWhere(
      (category) => category.id == id,
    );

    if (updated.length == originalLength) {
      return false;
    }

    categories.value = updated;
    return true;
  }
}