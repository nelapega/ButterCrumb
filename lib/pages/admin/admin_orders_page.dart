import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../models/order_model.dart';
import '../../services/order_service.dart';
import 'admin_order_detail_page.dart';

class AdminOrdersPage extends StatefulWidget {
  const AdminOrdersPage({super.key});

  @override
  State<AdminOrdersPage> createState() => _AdminOrdersPageState();
}

class _AdminOrdersPageState extends State<AdminOrdersPage> {
  final TextEditingController _searchController =
      TextEditingController();

  String _searchQuery = '';
  String _selectedFilter = 'Semua';

  final List<String> _filters = const [
    'Semua',
    'Menunggu',
    'Diproses',
    'Selesai',
    'Dibatalkan',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String _normalizeStatus(String status) {
    final value = status.toLowerCase();

    if (value.contains('cancel') || value.contains('batal')) {
      return 'Dibatalkan';
    }

    if (value.contains('complete') ||
        value.contains('selesai') ||
        value.contains('delivered')) {
      return 'Selesai';
    }

    if (value.contains('pending') ||
        value.contains('menunggu')) {
      return 'Menunggu';
    }

    return 'Diproses';
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'Menunggu':
        return const Color(0xFFB78639);
      case 'Diproses':
        return AppColors.mocha;
      case 'Selesai':
        return AppColors.success;
      case 'Dibatalkan':
        return AppColors.error;
      default:
        return AppColors.textSecondary;
    }
  }

  String _formatPrice(double price) {
    final raw = price.toStringAsFixed(0);

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

  List<OrderModel> _filterOrders(List<OrderModel> orders) {
    final query = _searchQuery.trim().toLowerCase();

    return orders.where((order) {
      final matchesStatus = _selectedFilter == 'Semua' ||
          _normalizeStatus(order.status) == _selectedFilter;

      final searchableText = [
        order.orderNumber,
        order.customerName,
        order.address,
        order.delivery,
        order.payment,
      ].join(' ').toLowerCase();

      final matchesSearch = searchableText.contains(query);

      return matchesStatus && matchesSearch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header dan pencarian
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 22, 20, 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(
                        Icons.receipt_long_rounded,
                        color: AppColors.chocolate,
                        size: 29,
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Kelola Pesanan',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppColors.darkBrown,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 7),
                  const Text(
                    'Pantau dan kelola pesanan pelanggan.',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 18),

                  TextField(
                    controller: _searchController,
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'Cari nomor atau nama pelanggan...',
                      prefixIcon: const Icon(
                        Icons.search_rounded,
                        color: AppColors.mocha,
                      ),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                              onPressed: () {
                                _searchController.clear();

                                setState(() {
                                  _searchQuery = '';
                                });
                              },
                              icon: const Icon(Icons.close),
                            )
                          : null,
                      filled: true,
                      fillColor: AppColors.cream,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(
                          color: AppColors.divider,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(
                          color: AppColors.divider,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(
                          color: AppColors.chocolate,
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Filter status
            SizedBox(
              height: 42,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                scrollDirection: Axis.horizontal,
                itemCount: _filters.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final filter = _filters[index];
                  final isSelected = _selectedFilter == filter;

                  return ChoiceChip(
                    label: Text(filter),
                    selected: isSelected,
                    onSelected: (_) {
                      setState(() {
                        _selectedFilter = filter;
                      });
                    },
                    selectedColor: AppColors.chocolate,
                    backgroundColor: AppColors.cream,
                    side: BorderSide(
                      color: isSelected
                          ? AppColors.chocolate
                          : AppColors.divider,
                    ),
                    showCheckmark: false,
                    labelStyle: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isSelected
                          ? Colors.white
                          : AppColors.chocolate,
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 12),

            // Daftar pesanan yang mengikuti OrderService
            Expanded(
              child: ValueListenableBuilder<List<OrderModel>>(
                valueListenable: OrderService.orders,
                builder: (context, orders, child) {
                  final filteredOrders = _filterOrders(orders);

                  if (orders.isEmpty) {
                    return _buildEmptyState(
                      icon: Icons.receipt_long_outlined,
                      title: 'Belum Ada Pesanan',
                      message:
                          'Pesanan pelanggan akan muncul di sini.',
                    );
                  }

                  if (filteredOrders.isEmpty) {
                    return _buildEmptyState(
                      icon: Icons.search_off_rounded,
                      title: 'Pesanan Tidak Ditemukan',
                      message:
                          'Coba kata kunci atau filter yang berbeda.',
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.fromLTRB(
                      20,
                      4,
                      20,
                      24,
                    ),
                    itemCount: filteredOrders.length,
                    itemBuilder: (context, index) {
                      final order = filteredOrders[index];
                      final status = _normalizeStatus(order.status);
                      final statusColor = _statusColor(status);

                      return Container(
                        margin: const EdgeInsets.only(bottom: 13),
                        decoration: BoxDecoration(
                          color: AppColors.cream,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: AppColors.divider,
                          ),
                        ),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(18),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    AdminOrderDetailPage(order: order),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      width: 43,
                                      height: 43,
                                      decoration: BoxDecoration(
                                        color: AppColors.softPink,
                                        borderRadius:
                                            BorderRadius.circular(13),
                                      ),
                                      child: const Icon(
                                        Icons.receipt_long_outlined,
                                        color: AppColors.chocolate,
                                      ),
                                    ),
                                    const SizedBox(width: 11),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            order.orderNumber,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: AppColors.darkBrown,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            _formatDate(order.createdAt),
                                            style: const TextStyle(
                                              fontSize: 11,
                                              color:
                                                  AppColors.textSecondary,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color:
                                            statusColor.withValues(alpha: 0.12),
                                        borderRadius:
                                            BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        status,
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w600,
                                          color: statusColor,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 15),
                                const Divider(
                                  color: AppColors.divider,
                                  height: 1,
                                ),
                                const SizedBox(height: 13),

                                Row(
                                  children: [
                                    const Icon(
                                      Icons.person_outline_rounded,
                                      size: 19,
                                      color: AppColors.mocha,
                                    ),
                                    const SizedBox(width: 7),
                                    Expanded(
                                      child: Text(
                                        order.customerName,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 13,
                                          color: AppColors.darkBrown,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 11),

                                Row(
                                  children: [
                                    const Icon(
                                      Icons.shopping_bag_outlined,
                                      size: 19,
                                      color: AppColors.mocha,
                                    ),
                                    const SizedBox(width: 7),
                                    Text(
                                      '${order.items.length} jenis produk',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                    const Spacer(),
                                    Text(
                                      _formatPrice(order.total),
                                      style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.chocolate,
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 13),

                                const Align(
                                  alignment: Alignment.centerRight,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'Lihat detail',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.chocolate,
                                        ),
                                      ),
                                      SizedBox(width: 4),
                                      Icon(
                                        Icons.arrow_forward_rounded,
                                        size: 16,
                                        color: AppColors.chocolate,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String message,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 88,
              height: 88,
              decoration: const BoxDecoration(
                color: AppColors.softPink,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 42,
                color: AppColors.chocolate,
              ),
            ),
            const SizedBox(height: 18),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.darkBrown,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}