import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../models/order_model.dart';
import '../../services/order_service.dart';

class AdminOrderDetailPage extends StatefulWidget {
  final OrderModel order;

  const AdminOrderDetailPage({
    super.key,
    required this.order,
  });

  @override
  State<AdminOrderDetailPage> createState() =>
      _AdminOrderDetailPageState();
}

class _AdminOrderDetailPageState
    extends State<AdminOrderDetailPage> {
  late String _selectedStatus;
  bool _isUpdating = false;

  // Nilai status disimpan dalam bahasa Inggris agar tetap
  // konsisten dengan default status di OrderModel.
  final List<Map<String, String>> _statusOptions = const [
    {'value': 'Pending', 'label': 'Menunggu'},
    {'value': 'Processing', 'label': 'Diproses'},
    {'value': 'Completed', 'label': 'Selesai'},
    {'value': 'Cancelled', 'label': 'Dibatalkan'},
  ];

  @override
  void initState() {
    super.initState();
    _selectedStatus = _normalizeStatus(widget.order.status);
  }

  String _normalizeStatus(String status) {
    final value = status.toLowerCase();

    if (value.contains('cancel') || value.contains('batal')) {
      return 'Cancelled';
    }

    if (value.contains('complete') ||
        value.contains('selesai') ||
        value.contains('delivered')) {
      return 'Completed';
    }

    if (value.contains('pending') ||
        value.contains('menunggu')) {
      return 'Pending';
    }

    return 'Processing';
  }

  String _statusLabel(String status) {
    switch (_normalizeStatus(status)) {
      case 'Pending':
        return 'Menunggu';
      case 'Completed':
        return 'Selesai';
      case 'Cancelled':
        return 'Dibatalkan';
      default:
        return 'Diproses';
    }
  }

  Color _statusColor(String status) {
    switch (_normalizeStatus(status)) {
      case 'Pending':
        return const Color(0xFFB78639);
      case 'Completed':
        return AppColors.success;
      case 'Cancelled':
        return AppColors.error;
      default:
        return AppColors.mocha;
    }
  }

  String _formatPrice(num value) {
    final raw = value.toStringAsFixed(0);

    final formatted = raw.replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
      (match) => '${match[1]}.',
    );

    return 'Rp $formatted';
  }

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');

    return '$day/$month/${date.year}';
  }

  // Memperoleh nama produk dari data Map item pesanan.
  String _itemName(Map<String, dynamic> item) {
    for (final key in ['productName', 'name', 'title']) {
      final value = item[key];

      if (value is String && value.trim().isNotEmpty) {
        return value;
      }
    }

    final product = item['product'];

    if (product is String && product.trim().isNotEmpty) {
      return product;
    }

    if (product is Map) {
      for (final key in ['name', 'productName', 'title']) {
        final value = product[key];

        if (value != null && value.toString().trim().isNotEmpty) {
          return value.toString();
        }
      }
    }

    // Jika produk tersimpan langsung sebagai object.
    try {
      final name = product.name;
      if (name != null) return name.toString();
    } catch (_) {
      // Tidak ada field name pada object tersebut.
    }

    return 'Produk';
  }

  int _itemQuantity(Map<String, dynamic> item) {
    final value = item['quantity'] ?? item['qty'] ?? 1;

    if (value is num) return value.toInt();

    return int.tryParse(value.toString()) ?? 1;
  }

  double _itemTotal(Map<String, dynamic> item) {
    final quantity = _itemQuantity(item);

    final lineTotal = item['lineTotal'] ??
        item['totalPrice'] ??
        item['subtotal'];

    if (lineTotal is num) return lineTotal.toDouble();

    if (lineTotal != null) {
      final parsed = double.tryParse(lineTotal.toString());
      if (parsed != null) return parsed;
    }

    dynamic price =
        item['price'] ?? item['unitPrice'] ?? item['productPrice'];

    // Jika harga berada di dalam object produk.
    if (price == null) {
      final product = item['product'];

      if (product is Map) {
        price = product['price'];
      } else {
        try {
          price = product.price;
        } catch (_) {
          price = null;
        }
      }
    }

    if (price is num) return price.toDouble() * quantity;

    return (double.tryParse(price?.toString() ?? '') ?? 0) *
        quantity;
  }

  void _showMessage(String message, {bool isError = false}) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor:
              isError ? AppColors.error : AppColors.chocolate,
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  void _updateStatus(String newStatus) {
    if (_isUpdating || newStatus == _selectedStatus) return;

    setState(() {
      _isUpdating = true;
    });

    try {
      final oldOrder = widget.order;

      // Membuat pesanan pengganti karena OrderModel belum memiliki
      // method copyWith().
      final updatedOrder = OrderModel(
        orderNumber: oldOrder.orderNumber,
        customerName: oldOrder.customerName,
        address: oldOrder.address,
        delivery: oldOrder.delivery,
        payment: oldOrder.payment,
        total: oldOrder.total,
        items: oldOrder.items,
        createdAt: oldOrder.createdAt,
        status: newStatus,
      );

      final updatedOrders =
          List<OrderModel>.from(OrderService.orders.value);

      final index = updatedOrders.indexWhere(
        (item) => item.orderNumber == oldOrder.orderNumber,
      );

      if (index == -1) {
        _showMessage(
          'Pesanan tidak ditemukan di OrderService.',
          isError: true,
        );
        return;
      }

      updatedOrders[index] = updatedOrder;
      OrderService.orders.value = updatedOrders;

      if (!mounted) return;

      setState(() {
        _selectedStatus = newStatus;
      });

      _showMessage(
        'Status pesanan berhasil diubah menjadi '
        '${_statusLabel(newStatus)}.',
      );
    } catch (error) {
      _showMessage(
        'Gagal memperbarui status: $error',
        isError: true,
      );
    } finally {
      if (mounted) {
        setState(() {
          _isUpdating = false;
        });
      }
    }
  }

  Widget _buildCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: AppColors.cream,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.divider),
      ),
      child: child,
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Icon(icon, color: AppColors.chocolate, size: 22),
          const SizedBox(width: 9),
          Text(
            title,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: AppColors.darkBrown,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(
    String label,
    String value, {
    IconData? icon,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon != null) ...[
            Icon(icon, color: AppColors.mocha, size: 19),
            const SizedBox(width: 10),
          ],
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          const Text(': '),
          Expanded(
            child: Text(
              value.isEmpty ? 'Belum tersedia' : value,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.darkBrown,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderItems() {
    final items = widget.order.items;

    if (items.isEmpty) {
      return _buildCard(
        child: const Text(
          'Tidak ada item dalam pesanan ini.',
          style: TextStyle(color: AppColors.textSecondary),
        ),
      );
    }

    return _buildCard(
      child: Column(
        children: [
          for (int i = 0; i < items.length; i++) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: AppColors.softPink,
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: const Icon(
                    Icons.cake_outlined,
                    color: AppColors.chocolate,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _itemName(items[i]),
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.darkBrown,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'Jumlah: ${_itemQuantity(items[i])}',
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  _formatPrice(_itemTotal(items[i])),
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.chocolate,
                  ),
                ),
              ],
            ),
            if (i < items.length - 1)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 14),
                child: Divider(color: AppColors.divider),
              ),
          ],
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final order = widget.order;
    final color = _statusColor(_selectedStatus);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Detail Pesanan',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.darkBrown,
        elevation: 0,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 30),
          children: [
            // Ringkasan
            _buildCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: AppColors.softPink,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(
                      Icons.receipt_long_rounded,
                      color: AppColors.chocolate,
                      size: 28,
                    ),
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    'Nomor Pesanan',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    order.orderNumber,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.darkBrown,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _formatDate(order.createdAt),
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      _statusLabel(_selectedStatus),
                      style: TextStyle(
                        color: color,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Pelanggan
            _buildCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle(
                    'Informasi Pelanggan',
                    Icons.person_outline_rounded,
                  ),
                  _buildInfoRow(
                    'Nama',
                    order.customerName,
                    icon: Icons.person_outline,
                  ),
                  _buildInfoRow(
                    'Alamat',
                    order.address,
                    icon: Icons.location_on_outlined,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            _buildSectionTitle(
              'Item Pesanan',
              Icons.shopping_bag_outlined,
            ),
            _buildOrderItems(),

            const SizedBox(height: 20),

            // Pengiriman dan pembayaran
            _buildCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle(
                    'Pengiriman & Pembayaran',
                    Icons.local_shipping_outlined,
                  ),
                  _buildInfoRow(
                    'Pengiriman',
                    order.delivery,
                    icon: Icons.delivery_dining_outlined,
                  ),
                  _buildInfoRow(
                    'Pembayaran',
                    order.payment,
                    icon: Icons.payments_outlined,
                  ),
                  const Divider(color: AppColors.divider),
                  const SizedBox(height: 13),
                  Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'Total Pesanan',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.darkBrown,
                          ),
                        ),
                      ),
                      Text(
                        _formatPrice(order.total),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.chocolate,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Status
            _buildCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle(
                    'Kelola Status Pesanan',
                    Icons.edit_note_rounded,
                  ),
                  const Text(
                    'Pilih status terbaru untuk pesanan pelanggan.',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 14),
                  DropdownButtonFormField<String>(
                    initialValue: _selectedStatus,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: AppColors.background,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(
                          color: AppColors.divider,
                        ),
                      ),
                    ),
                    items: _statusOptions.map((option) {
                      return DropdownMenuItem<String>(
                        value: option['value']!,
                        child: Text(option['label']!),
                      );
                    }).toList(),
                    onChanged: _isUpdating
                        ? null
                        : (value) {
                            if (value != null) {
                              _updateStatus(value);
                            }
                          },
                  ),
                  const SizedBox(height: 14),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: OutlinedButton.icon(
                      onPressed: _isUpdating
                          ? null
                          : () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back_rounded),
                      label: const Text('Kembali ke Pesanan'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.chocolate,
                        side: const BorderSide(
                          color: AppColors.divider,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}