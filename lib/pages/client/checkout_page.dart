
import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../services/cart_service.dart';
import 'order_success_page.dart';
import '../../models/order_model.dart';
import '../../services/order_service.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();

  String _delivery = 'Standard Delivery';
  String _payment = 'Cash on Delivery';

  static const double _deliveryFee = 10000;

  double get _total {
    if (CartService.count == 0) return 0;

    final fee = _delivery == 'Express Delivery'
        ? 20000.0
        : _deliveryFee;

    return CartService.subtotal + fee;
  }

  String rupiah(double value) {
    final formatted = value.toInt().toString().replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (_) => '.',
    );
    return 'Rp $formatted';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _placeOrder() {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) return;

    if (CartService.count == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Keranjang kamu masih kosong.')),
      );
      return;
    }

    final orderNumber =
        'BC${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';

    final orderItems = CartService.products.map((product) {
      return {
        'name': product.name,
        'price': product.price,
        'quantity': CartService.items.value[product.id] ?? 0,
      };
    }).toList();

    final orderTotal = _total;

    OrderService.add(
      OrderModel(
        orderNumber: orderNumber,
        customerName: _nameController.text.trim(),
        address: _addressController.text.trim(),
        delivery: _delivery,
        payment: _payment,
        total: orderTotal,
        items: orderItems,
        createdAt: DateTime.now(),
      ),
    );

CartService.clear();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => OrderSuccessPage(
          orderNumber: orderNumber,
          customerName: _nameController.text.trim(),
          address: _addressController.text.trim(),
          delivery: _delivery,
          payment: _payment,
          total: orderTotal,
          items: orderItems,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: AppColors.softCream,
      appBar: AppBar(
        backgroundColor: AppColors.softCream,
        title: Text('Checkout', style: textTheme.titleLarge),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 30),
          children: [
            _sectionTitle('Delivery Address'),
            const SizedBox(height: 12),

            _field(
              controller: _nameController,
              label: 'Full Name',
              hint: 'Enter recipient name',
              icon: Icons.person_outline_rounded,
            ),
            const SizedBox(height: 12),

            _field(
              controller: _phoneController,
              label: 'Phone Number',
              hint: '08xxxxxxxxxx',
              icon: Icons.phone_outlined,
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 12),

            _field(
              controller: _addressController,
              label: 'Complete Address',
              hint: 'Street, house number, district...',
              icon: Icons.location_on_outlined,
              maxLines: 3,
            ),

            const SizedBox(height: 26),
            _sectionTitle('Delivery Option'),
            const SizedBox(height: 12),

            _optionTile(
              title: 'Standard Delivery',
              subtitle: 'Estimated 2–3 days',
              trailing: rupiah(_deliveryFee),
              value: 'Standard Delivery',
              groupValue: _delivery,
              onChanged: (value) {
                setState(() => _delivery = value!);
              },
            ),

            _optionTile(
              title: 'Express Delivery',
              subtitle: 'Estimated 1 day',
              trailing: rupiah(20000),
              value: 'Express Delivery',
              groupValue: _delivery,
              onChanged: (value) {
                setState(() => _delivery = value!);
              },
            ),

            const SizedBox(height: 26),
            _sectionTitle('Payment Method'),
            const SizedBox(height: 12),

            _optionTile(
              title: 'Cash on Delivery',
              subtitle: 'Pay when your order arrives',
              trailing: '',
              value: 'Cash on Delivery',
              groupValue: _payment,
              onChanged: (value) {
                setState(() => _payment = value!);
              },
            ),

            _optionTile(
              title: 'Bank Transfer',
              subtitle: 'Demo option — no real transfer',
              trailing: '',
              value: 'Bank Transfer',
              groupValue: _payment,
              onChanged: (value) {
                setState(() => _payment = value!);
              },
            ),

            const SizedBox(height: 26),
            _sectionTitle('Order Summary'),
            const SizedBox(height: 12),

            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppColors.cream,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  ...CartService.products.map((product) {
                    final quantity =
                        CartService.items.value[product.id] ?? 0;

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              '${product.name} × $quantity',
                              style: textTheme.bodyMedium,
                            ),
                          ),
                          Text(rupiah(product.price * quantity)),
                        ],
                      ),
                    );
                  }),
                  const Divider(height: 24),
                  _summaryRow('Subtotal', CartService.subtotal),
                  const SizedBox(height: 10),
                  _summaryRow(
                    'Delivery Fee',
                    _delivery == 'Express Delivery'
                        ? 20000
                        : _deliveryFee,
                  ),
                  const Divider(height: 24),
                  _summaryRow(
                    'Total',
                    CartService.subtotal +
                        (_delivery == 'Express Delivery'
                            ? 20000
                            : _deliveryFee),
                    bold: true,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            SizedBox(
              height: 54,
              child: ElevatedButton(
                onPressed: _placeOrder,
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.lock_outline_rounded),
                    SizedBox(width: 10),
                    Text('Place Order'),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 12),
            Text(
              'Demo checkout · No real payment will be processed.',
              textAlign: TextAlign.center,
              style: textTheme.bodySmall?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleLarge,
    );
  }

  Widget _field({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: 7),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return '$label wajib diisi.';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _optionTile({
    required String title,
    required String subtitle,
    required String trailing,
    required String value,
    required String groupValue,
    required ValueChanged<String?> onChanged,
  }) {
    final selected = value == groupValue;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppColors.cream,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: selected ? AppColors.mocha : AppColors.divider,
          width: selected ? 1.5 : 1,
        ),
      ),
      child: RadioGroup<String>(
        groupValue: groupValue,
        onChanged: onChanged,
        child: RadioListTile<String>(
          value: value,
          activeColor: AppColors.chocolate,
          title: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          subtitle: Text(subtitle),
          secondary: trailing.isEmpty
              ? null
              : Text(
                  trailing,
                  style: const TextStyle(
                    color: AppColors.chocolate,
                    fontWeight: FontWeight.w600,
                  ),
                ),
        ),
      ),
    );
  }

  Widget _summaryRow(
    String label,
    double value, {
    bool bold = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: bold ? FontWeight.w700 : FontWeight.w400,
          ),
        ),
        Text(
          rupiah(value),
          style: TextStyle(
            fontWeight: bold ? FontWeight.w700 : FontWeight.w500,
            fontSize: bold ? 17 : 14,
            color: AppColors.chocolate,
          ),
        ),
      ],
    );
  }
}
