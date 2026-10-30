
import 'package:flutter/foundation.dart';

import '../models/product_model.dart';

class ProductService {
  ProductService._();

  // Satu sumber data produk untuk seluruh aplikasi.
  static final ValueNotifier<List<ProductModel>> products =
      ValueNotifier<List<ProductModel>>(
    List<ProductModel>.from(ProductModel.samples),
  );

  static List<ProductModel> getAllProducts() {
    return List<ProductModel>.unmodifiable(products.value);
  }

  static ProductModel? getProductById(String id) {
    for (final product in products.value) {
      if (product.id == id) return product;
    }
    return null;
  }

  // Menambahkan produk baru.
  static void addProduct(ProductModel product) {
    if (product.stock < 0) {
      throw ArgumentError('Stok tidak boleh kurang dari nol.');
    }

    final exists = products.value.any((item) => item.id == product.id);

    if (exists) {
      throw ArgumentError('ID produk sudah digunakan.');
    }

    products.value = [...products.value, product];
  }

  // Memperbarui data produk tanpa kehilangan stok terbaru.
  static bool updateProduct(ProductModel updatedProduct) {
    if (updatedProduct.stock < 0) {
      throw ArgumentError('Stok tidak boleh kurang dari nol.');
    }

    final updated = List<ProductModel>.from(products.value);
    final index = updated.indexWhere(
      (product) => product.id == updatedProduct.id,
    );

    if (index == -1) return false;

    updated[index] = updatedProduct;
    products.value = updated;
    return true;
  }

  // Mengubah stok menjadi jumlah tertentu.
  // Cocok untuk admin yang memperbarui stok.
  static bool setStock(String id, int newStock) {
    if (newStock < 0) {
      throw ArgumentError('Stok tidak boleh kurang dari nol.');
    }

    final product = getProductById(id);
    if (product == null) return false;

    return updateProduct(product.copyWith(stock: newStock));
  }

  // Menambah stok, misalnya saat admin menerima barang baru.
  static bool increaseStock(String id, int quantity) {
    if (quantity <= 0) {
      throw ArgumentError('Jumlah penambahan harus lebih dari nol.');
    }

    final product = getProductById(id);
    if (product == null) return false;

    return updateProduct(
      product.copyWith(stock: product.stock + quantity),
    );
  }

  // Mengurangi stok jika jumlah tersedia mencukupi.
  static bool decreaseStock(String id, int quantity) {
    if (quantity <= 0) {
      throw ArgumentError('Jumlah pengurangan harus lebih dari nol.');
    }

    final product = getProductById(id);
    if (product == null || product.stock < quantity) {
      return false;
    }

    return updateProduct(
      product.copyWith(stock: product.stock - quantity),
    );
  }

  // Menghapus produk.
  static bool deleteProduct(String id) {
    final updated = List<ProductModel>.from(products.value);
    final originalLength = updated.length;

    updated.removeWhere((product) => product.id == id);

    if (updated.length == originalLength) return false;

    products.value = updated;
    return true;
  }

  static List<ProductModel> getProductsByCategory(String category) {
    if (category.toLowerCase() == 'all') return getAllProducts();

    return products.value
        .where(
          (product) =>
              product.category.toLowerCase() == category.toLowerCase(),
        )
        .toList();
  }

  static List<ProductModel> searchProducts(String query) {
    final keyword = query.trim().toLowerCase();

    if (keyword.isEmpty) return getAllProducts();

    return products.value.where((product) {
      return product.name.toLowerCase().contains(keyword) ||
          product.category.toLowerCase().contains(keyword) ||
          product.description.toLowerCase().contains(keyword);
    }).toList();
  }

  static List<ProductModel> getPopularProducts() {
    return products.value
        .where((product) => product.isPopular)
        .toList();
  }

  static List<ProductModel> getProductsByRating(double minimumRating) {
    return products.value
        .where((product) => product.rating >= minimumRating)
        .toList();
  }

  static List<ProductModel> getProductsByPriceRange({
    required double minPrice,
    required double maxPrice,
  }) {
    return products.value
        .where(
          (product) =>
              product.price >= minPrice && product.price <= maxPrice,
        )
        .toList();
  }
}
