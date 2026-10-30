class OrderModel {
  final String orderNumber;
  final String customerName;
  final String address;
  final String delivery;
  final String payment;
  final double total;
  final List<Map<String, dynamic>> items;
  final DateTime createdAt;
  final String status;

  OrderModel({
    required this.orderNumber,
    required this.customerName,
    required this.address,
    required this.delivery,
    required this.payment,
    required this.total,
    required this.items,
    required this.createdAt,
    this.status = 'Processing',
  });
}
