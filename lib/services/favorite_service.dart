
import 'package:flutter/foundation.dart';

import '../models/product_model.dart';

class FavoriteService {
  FavoriteService._();

  static final ValueNotifier<List<ProductModel>> favorites =
      ValueNotifier<List<ProductModel>>([]);

  static bool isFavorite(ProductModel product) {
    return favorites.value.any((item) => item.id == product.id);
  }

  static void toggle(ProductModel product) {
    final updated = List<ProductModel>.from(favorites.value);

    if (updated.any((item) => item.id == product.id)) {
      updated.removeWhere((item) => item.id == product.id);
    } else {
      updated.insert(0, product);
    }

    favorites.value = updated;
  }

  static void remove(ProductModel product) {
    favorites.value = favorites.value
        .where((item) => item.id != product.id)
        .toList();
  }
}
