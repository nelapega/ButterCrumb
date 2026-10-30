
import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import 'order_history_page.dart';

class OrderSuccessPage extends StatelessWidget {
  final String orderNumber;
  final String customerName;
  final String address;
  final String delivery;
  final String payment;
  final double total;
  final List<Map<String, dynamic>> items;

  const OrderSuccessPage({
    super.key,
    required this.orderNumber,
    required this.customerName,
    required this.address,
    required this.delivery,
    required this.payment,
    required this.total,
    required this.items,
  });

  String _rupiah(double value) {
    final formatted = value.toInt().toString().replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (_) => '.',
    );

    return 'Rp $formatted';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            const SizedBox(height: 45),
            Center(
              child: Container(
                width: 125,
                height: 125,
                decoration: const BoxDecoration(
                  color: AppColors.softPink,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle_rounded,
                  size: 85,
                  color: AppColors.success,
                ),
              ),
            ),
            const SizedBox(height: 28),
            const Text(
              'Pesanan Berhasil!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: AppColors.darkBrown,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Terima kasih sudah memesan di Butter & Crumb 🤎',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 28),

            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.cream,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.divider),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Nomor Pesanan',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  SelectableText(
                    orderNumber,
                    style: const TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                      color: AppColors.chocolate,
                    ),
                  ),
                  const Divider(height: 28),
                  _infoRow('Nama penerima', customerName),
                  _infoRow('Alamat', address),
                  _infoRow('Pengiriman', delivery),
                  _infoRow('Pembayaran', payment),
                  const Divider(height: 24),
                  const Text(
                    'Detail Produk',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.darkBrown,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...items.map((item) {
                    final name = item['name']?.toString() ?? 'Produk';
                    final quantity =
                        (item['quantity'] as num?)?.toInt() ?? 0;
                    final price =
                        (item['price'] as num?)?.toDouble() ?? 0;

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              '$name × $quantity',
                              style: const TextStyle(
                                color: AppColors.darkBrown,
                              ),
                            ),
                          ),
                          Text(
                            _rupiah(price * quantity),
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              color: AppColors.chocolate,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                  const Divider(height: 24),
                  Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'Total Pembayaran',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.darkBrown,
                          ),
                        ),
                      ),
                      Text(
                        _rupiah(total),
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

            const SizedBox(height: 24),
            SizedBox(
              height: 54,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const OrderHistoryPage(),
                    ),
                    (route) => route.isFirst,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.chocolate,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  'Lihat Pesanan Saya',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 10),
            OutlinedButton(
              onPressed: () {
                Navigator.popUntil(context, (route) => route.isFirst);
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.chocolate,
                side: const BorderSide(color: AppColors.chocolate),
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('Kembali ke Beranda'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 125,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
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
}
