
import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../models/order_model.dart';
import '../../services/order_service.dart';

class OrderHistoryPage extends StatelessWidget {
  const OrderHistoryPage({super.key});

  String _formatDate(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
      'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des',
    ];

    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  String _formatPrice(double price) {
    final value = price.toInt().toString();
    final buffer = StringBuffer();

    for (int i = 0; i < value.length; i++) {
      buffer.write(value[i]);

      final remaining = value.length - i - 1;
      if (remaining > 0 && remaining % 3 == 0) {
        buffer.write('.');
      }
    }

    return 'Rp$buffer';
  }

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
      case 'delivered':
      case 'selesai':
        return AppColors.success;
      case 'cancelled':
      case 'dibatalkan':
        return AppColors.error;
      default:
        return AppColors.mocha;
    }
  }

  String _statusLabel(String status) {
    switch (status.toLowerCase()) {
      case 'processing':
        return 'Sedang Diproses';
      case 'confirmed':
        return 'Pesanan Dikonfirmasi';
      case 'shipped':
        return 'Dalam Pengiriman';
      case 'delivered':
      case 'completed':
        return 'Pesanan Selesai';
      case 'cancelled':
        return 'Pesanan Dibatalkan';
      default:
        return status;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Pesanan Saya',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: ValueListenableBuilder<List<OrderModel>>(
        valueListenable: OrderService.orders,
        builder: (context, orders, child) {
          if (orders.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(28),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 110,
                      height: 110,
                      decoration: const BoxDecoration(
                        color: AppColors.softPink,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.receipt_long_rounded,
                        size: 54,
                        color: AppColors.chocolate,
                      ),
                    ),
                    const SizedBox(height: 22),
                    const Text(
                      'Belum Ada Pesanan',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.darkBrown,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Pesanan yang kamu buat akan muncul di sini.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(18),
            itemCount: orders.length,
            separatorBuilder: (_, _) => const SizedBox(height: 14),
            itemBuilder: (context, index) {
              final order = orders[index];
              final statusColor = _statusColor(order.status);

              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.cream,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.divider),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.receipt_long_rounded,
                          color: AppColors.chocolate,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            order.orderNumber,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.darkBrown,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: statusColor.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            _statusLabel(order.status),
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: statusColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      _formatDate(order.createdAt),
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const Divider(height: 24),
                    Text(
                      '${order.items.length} jenis produk',
                      style: const TextStyle(
                        color: AppColors.darkBrown,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Penerima: ${order.customerName}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Pengiriman: ${order.delivery}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Pembayaran: ${order.payment}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const Expanded(
                          child: Text(
                            'Total Pesanan',
                            style: TextStyle(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                        Text(
                          _formatPrice(order.total),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.chocolate,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Divider(),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(
                          Icons.local_shipping_outlined,
                          color: AppColors.mocha,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _statusLabel(order.status),
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              color: AppColors.darkBrown,
                            ),
                          ),
                        ),
                        const Icon(
                          Icons.check_circle_outline_rounded,
                          color: AppColors.success,
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
