
import 'package:flutter/foundation.dart';

import '../models/product_model.dart';
import 'product_service.dart';

class CartService {
  CartService._();

  // Menyimpan ID produk dan jumlahnya di keranjang.
  static final ValueNotifier<Map<String, int>> items =
      ValueNotifier<Map<String, int>>({});

  // Mengambil data produk terbaru dari ProductService.
  static List<ProductModel> get products {
    final cartIds = items.value.keys.toSet();

    return ProductService.products.value
        .where((product) => cartIds.contains(product.id))
        .toList();
  }

  // Total kuantitas seluruh produk.
  static int get count {
    return items.value.values.fold(
      0,
      (total, quantity) => total + quantity,
    );
  }

  // Total harga produk dalam keranjang.
  static double get subtotal {
    return products.fold(
      0,
      (total, product) =>
          total + product.price * (items.value[product.id] ?? 0),
    );
  }

  // Menambahkan satu barang dan langsung mengurangi stok.
  // Mengembalikan false jika produk tidak ada atau stok habis.
  static bool add(ProductModel product) {
    final currentProduct = ProductService.getProductById(product.id);

    if (currentProduct == null || currentProduct.stock <= 0) {
      return false;
    }

    final success = ProductService.decreaseStock(product.id, 1);

    if (!success) return false;

    final updated = Map<String, int>.from(items.value);
    updated[product.id] = (updated[product.id] ?? 0) + 1;
    items.value = updated;

    return true;
  }

  // Menambah jumlah barang dan mengurangi stok lagi.
  static bool increase(String id) {
    if (!items.value.containsKey(id)) return false;

    final product = ProductService.getProductById(id);

    if (product == null || product.stock <= 0) {
      return false;
    }

    final success = ProductService.decreaseStock(id, 1);

    if (!success) return false;

    final updated = Map<String, int>.from(items.value);
    updated[id] = updated[id]! + 1;
    items.value = updated;

    return true;
  }

  // Mengurangi jumlah barang dan mengembalikan satu stok.
  // Jika jumlahnya tinggal satu, produk dihapus dari keranjang.
  static bool decrease(String id) {
    final updated = Map<String, int>.from(items.value);
    final quantity = updated[id];

    if (quantity == null) return false;

    final success = ProductService.increaseStock(id, 1);

    if (!success) return false;

    if (quantity <= 1) {
      updated.remove(id);
    } else {
      updated[id] = quantity - 1;
    }

    items.value = updated;
    return true;
  }

  // Menghapus seluruh jumlah produk dan mengembalikan stoknya.
  static bool remove(String id) {
    final updated = Map<String, int>.from(items.value);
    final quantity = updated[id];

    if (quantity == null) return false;

    final success = ProductService.increaseStock(id, quantity);

    if (!success) return false;

    updated.remove(id);
    items.value = updated;

    return true;
  }

  // Kosongkan keranjang setelah pesanan berhasil dibuat.
  // Stok tidak dikembalikan karena sudah terpakai oleh pesanan.
  static void clear() {
    items.value = {};
  }
}
