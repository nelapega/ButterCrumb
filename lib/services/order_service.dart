import 'package:flutter/foundation.dart';
import '../models/order_model.dart';

class OrderService {
  OrderService._();

  static final ValueNotifier<List<OrderModel>> orders =
      ValueNotifier<List<OrderModel>>([]);

  static void add(OrderModel order) {
    orders.value = [order, ...orders.value];
  }

  static void clear() {
    orders.value = [];
  }
}
