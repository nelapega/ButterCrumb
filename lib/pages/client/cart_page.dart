
import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../models/product_model.dart';
import '../../services/cart_service.dart';
import '../client/checkout_page.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  String rupiah(double value) {
    final formatted = value.toInt().toString().replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (_) => '.',
    );
    return 'Rp $formatted';
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return ValueListenableBuilder<Map<String, int>>(
      valueListenable: CartService.items,
      builder: (context, cart, _) {
        final products = ProductModel.samples
            .where((product) => cart.containsKey(product.id))
            .toList();

        final subtotal = CartService.subtotal;
        const deliveryFee = 10000.0;
        final total = subtotal == 0 ? 0.0 : subtotal + deliveryFee;

        return Scaffold(
          backgroundColor: AppColors.softCream,
          appBar: AppBar(
            backgroundColor: AppColors.softCream,
            title: Text('My Cart', style: textTheme.titleLarge),
            centerTitle: true,
          ),
          body: products.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(28),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          decoration: const BoxDecoration(
                            color: AppColors.softPink,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.shopping_bag_outlined,
                            size: 48,
                            color: AppColors.chocolate,
                          ),
                        ),
                        const SizedBox(height: 22),
                        Text(
                          'Your cart is empty',
                          style: textTheme.headlineMedium,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Yuk, pilih cake dan bakery favoritmu!',
                          textAlign: TextAlign.center,
                          style: textTheme.bodyMedium?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 22),
                        ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Explore Bakery'),
                        ),
                      ],
                    ),
                  ),
                )
              : ListView(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                  children: [
                    Text(
                      '${CartService.count} item in your bag',
                      style: textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 16),

                    ...products.map((product) {
                      final quantity = cart[product.id] ?? 0;

                      return Container(
                        margin: const EdgeInsets.only(bottom: 14),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.cream,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: AppColors.divider,
                          ),
                        ),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(14),
                              child: Image.network(
                                product.image,
                                width: 88,
                                height: 94,
                                fit: BoxFit.cover,
                                errorBuilder: (_, _, _) {
                                  return Container(
                                    width: 88,
                                    height: 94,
                                    color: AppColors.softPink,
                                    child: const Icon(
                                      Icons.cake_rounded,
                                      color: AppColors.mocha,
                                    ),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    product.name,
                                    style: textTheme.titleMedium,
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    product.category,
                                    style: textTheme.bodySmall?.copyWith(
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                  const SizedBox(height: 9),
                                  Text(
                                    rupiah(product.price),
                                    style: textTheme.titleSmall?.copyWith(
                                      color: AppColors.chocolate,
                                    ),
                                  ),
                                  const SizedBox(height: 9),
                                  Row(
                                    children: [
                                      _quantityButton(
                                        icon: Icons.remove,
                                        onTap: () =>
                                            CartService.decrease(product.id),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                        ),
                                        child: Text(
                                          '$quantity',
                                          style: textTheme.titleSmall,
                                        ),
                                      ),
                                      _quantityButton(
                                        icon: Icons.add,
                                        onTap: () =>
                                            CartService.increase(product.id),
                                      ),
                                      const Spacer(),
                                      IconButton(
                                        tooltip: 'Remove item',
                                        visualDensity:
                                            VisualDensity.compact,
                                        onPressed: () =>
                                            CartService.remove(product.id),
                                        icon: const Icon(
                                          Icons.delete_outline_rounded,
                                          color: AppColors.mocha,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }),

                    const SizedBox(height: 10),

                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: AppColors.cream,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          _priceRow(
                            'Subtotal',
                            rupiah(subtotal),
                          ),
                          const SizedBox(height: 12),
                          _priceRow(
                            'Delivery Fee',
                            rupiah(deliveryFee),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 14),
                            child: Divider(),
                          ),
                          _priceRow(
                            'Total',
                            rupiah(total),
                            bold: true,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 22),

                    SizedBox(
                      height: 54,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const CheckoutPage(),
                            ),
                          );
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.lock_outline_rounded),
                            const SizedBox(width: 10),
                            Text('Proceed to Checkout · ${rupiah(total)}'),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
        );
      },
    );
  }

  Widget _quantityButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Material(
      color: AppColors.softPink,
      borderRadius: BorderRadius.circular(9),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(9),
        child: SizedBox(
          width: 28,
          height: 28,
          child: Icon(
            icon,
            size: 17,
            color: AppColors.chocolate,
          ),
        ),
      ),
    );
  }

  Widget _priceRow(
    String label,
    String value, {
    bool bold = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: AppColors.textSecondary,
            fontWeight: bold ? FontWeight.w700 : FontWeight.w400,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: AppColors.chocolate,
            fontWeight: bold ? FontWeight.w700 : FontWeight.w500,
            fontSize: bold ? 17 : 14,
          ),
        ),
      ],
    );
  }
}
