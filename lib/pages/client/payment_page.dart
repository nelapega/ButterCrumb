
import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';

class PaymentPage extends StatefulWidget {
  final double total;
  final String customerName;
  final String address;
  final String delivery;

  const PaymentPage({
    super.key,
    required this.total,
    required this.customerName,
    required this.address,
    required this.delivery,
  });

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  String _selectedPayment = 'Transfer Bank';

  final List<Map<String, dynamic>> _paymentMethods = [
    {
      'name': 'Transfer Bank',
      'icon': Icons.account_balance_rounded,
      'description': 'Transfer melalui rekening bank',
    },
    {
      'name': 'E-Wallet',
      'icon': Icons.account_balance_wallet_rounded,
      'description': 'Pembayaran dompet digital',
    },
    {
      'name': 'COD',
      'icon': Icons.payments_outlined,
      'description': 'Bayar saat pesanan diterima',
    },
  ];

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

  void _continuePayment() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Metode $_selectedPayment dipilih. '
          'Selanjutnya kita sambungkan ke konfirmasi pesanan.',
        ),
        backgroundColor: AppColors.chocolate,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Pembayaran',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.darkBrown,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  const Text(
                    'Pilih Metode Pembayaran',
                    style: TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                      color: AppColors.darkBrown,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Pilih metode pembayaran yang paling nyaman untukmu.',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 22),

                  ..._paymentMethods.map((method) {
                    final selected =
                        _selectedPayment == method['name'];

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedPayment = method['name'] as String;
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 14),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.cream,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: selected
                                ? AppColors.chocolate
                                : AppColors.divider,
                            width: selected ? 2 : 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: AppColors.softPink,
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Icon(
                                method['icon'] as IconData,
                                color: AppColors.chocolate,
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    method['name'] as String,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.darkBrown,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    method['description'] as String,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Icon(
                              selected
                                  ? Icons.radio_button_checked
                                  : Icons.radio_button_off,
                              color: selected
                                  ? AppColors.chocolate
                                  : AppColors.textSecondary,
                            ),
                          ],
                        ),
                      ),
                    );
                  }),

                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: AppColors.softCream,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Ringkasan Pesanan',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.darkBrown,
                          ),
                        ),
                        const SizedBox(height: 14),
                        _summaryRow('Nama penerima', widget.customerName),
                        _summaryRow('Pengiriman', widget.delivery),
                        _summaryRow('Alamat', widget.address),
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
                              _formatPrice(widget.total),
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
                ],
              ),
            ),

            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: AppColors.cream,
                border: Border(
                  top: BorderSide(color: AppColors.divider),
                ),
              ),
              child: SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: _continuePayment,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.chocolate,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    'Lanjutkan Pembayaran',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _summaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 115,
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
