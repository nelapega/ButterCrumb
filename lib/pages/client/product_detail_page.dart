
import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../models/product_model.dart';
import '../../services/cart_service.dart';

class ProductDetailPage extends StatefulWidget {
  final ProductModel product;

  const ProductDetailPage({
    super.key,
    required this.product,
  });

  @override
  State<ProductDetailPage> createState() =>
      _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  int quantity = 1;

  String get formattedPrice {
    return 'Rp ${widget.product.price.toStringAsFixed(0)}';
  }

  String formatCurrency(double price) {
    return 'Rp ${price.toStringAsFixed(0)}';
  }

  void addToCart() {
    for (int i = 0; i < quantity; i++) {
      CartService.add(widget.product);
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '$quantity ${widget.product.name} berhasil ditambahkan ke keranjang!',
        ),
        backgroundColor: AppColors.chocolate,
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: 'OK',
          textColor: Colors.white,
          onPressed: () {},
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    return Scaffold(
      backgroundColor: AppColors.softCream,
      body: SafeArea(
        child: Column(
          children: [
            // BAGIAN FOTO DAN TOMBOL KEMBALI
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          height: 330,
                          child: Image.network(
                            product.image,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: AppColors.cream,
                                child: const Center(
                                  child: Icon(
                                    Icons.cake_outlined,
                                    size: 80,
                                    color: Colors.brown,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),

                        Positioned(
                          top: 16,
                          left: 16,
                          child: _roundButton(
                            icon: Icons.arrow_back,
                            onTap: () => Navigator.pop(context),
                          ),
                        ),

                        Positioned(
                          top: 16,
                          right: 16,
                          child: _roundButton(
                            icon: Icons.shopping_bag_outlined,
                            onTap: () {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Produk siap ditambahkan ke keranjang 🤎',
                                  ),
                                ),
                              );
                            },
                          ),
                        ),

                        if (product.isPopular)
                          Positioned(
                            bottom: 18,
                            left: 18,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.softPink,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Text(
                                'BEST SELLER ✨',
                                style: TextStyle(
                                  color: Color(0xFF704331),
                                  fontWeight: FontWeight.w700,
                                  fontSize: 11,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),

                    // INFORMASI PRODUK
                    Padding(
                      padding: const EdgeInsets.fromLTRB(
                        22, 24, 22, 30,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product.category.toUpperCase(),
                            style: TextStyle(
                              color: AppColors.mocha,
                              fontSize: 12,
                              letterSpacing: 2,
                              fontWeight: FontWeight.w700,
                            ),
                          ),

                          const SizedBox(height: 8),

                          Text(
                            product.name,
                            style: TextStyle(
                              color: AppColors.chocolate,
                              fontSize: 27,
                              fontWeight: FontWeight.w800,
                            ),
                          ),

                          const SizedBox(height: 14),

                          Row(
                            children: [
                              const Icon(
                                Icons.star_rounded,
                                color: Color(0xFFE4A545),
                                size: 22,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                product.rating.toString(),
                                style: TextStyle(
                                  color: AppColors.chocolate,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '• Freshly baked with love',
                                style: TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 22),

                          Text(
                            'About this treat',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                              color: AppColors.chocolate,
                            ),
                          ),

                          const SizedBox(height: 9),

                          Text(
                            product.description,
                            style: TextStyle(
                              fontSize: 14,
                              height: 1.7,
                              color: AppColors.textSecondary,
                            ),
                          ),

                          const SizedBox(height: 24),

                          // PILIH JUMLAH
                          Row(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Quantity',
                                style: TextStyle(
                                  color: AppColors.chocolate,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16,
                                ),
                              ),

                              Container(
                                decoration: BoxDecoration(
                                  color: AppColors.cream,
                                  borderRadius:
                                      BorderRadius.circular(14),
                                ),
                                child: Row(
                                  children: [
                                    IconButton(
                                      onPressed: quantity > 1
                                          ? () {
                                              setState(() {
                                                quantity--;
                                              });
                                            }
                                          : null,
                                      icon: const Icon(
                                        Icons.remove,
                                      ),
                                    ),

                                    Text(
                                      '$quantity',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.chocolate,
                                        fontSize: 16,
                                      ),
                                    ),

                                    IconButton(
                                      onPressed: () {
                                        setState(() {
                                          quantity++;
                                        });
                                      },
                                      icon: const Icon(
                                        Icons.add,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 24),

                          // RINGKASAN HARGA
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppColors.cream,
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Total price',
                                  style: TextStyle(
                                    color: AppColors.textSecondary,
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  formatCurrency(
                                    product.price * quantity,
                                  ),
                                  style: TextStyle(
                                    color: AppColors.chocolate,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // TOMBOL ADD TO CART
            Container(
              padding: const EdgeInsets.fromLTRB(
                22, 14, 22, 18,
              ),
              decoration: BoxDecoration(
                color: AppColors.softCream,
                border: Border(
                  top: BorderSide(
                    color: AppColors.divider,
                  ),
                ),
              ),
              child: SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: addToCart,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.chocolate,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.shopping_bag_outlined,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Add to Cart • $formattedPrice',
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _roundButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.white.withValues(alpha: 0.92),
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: 44,
          height: 44,
          child: Icon(
            icon,
            color: AppColors.chocolate,
            size: 22,
          ),
        ),
      ),
    );
  }
}
