
import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../models/product_model.dart';
import '../services/favorite_service.dart';

class ProductCard extends StatelessWidget {
  final ProductModel product;
  final VoidCallback onAdd;
  final VoidCallback? onTap;

  const ProductCard({
    super.key,
    required this.product,
    required this.onAdd,
    this.onTap,
  });

  String get formattedPrice {
    final price = product.price.toInt().toString();
    return price.replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (match) => '.',
    ).replaceFirstMapped(
      RegExp(r'^'),
      (match) => 'Rp ',
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
      decoration: BoxDecoration(
        color: AppColors.cream,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.divider),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 6,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.network(
                  product.image,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: AppColors.softPink,
                      child: const Icon(
                        Icons.cake_rounded,
                        size: 55,
                        color: AppColors.mocha,
                      ),
                    );
                  },
                ),

                // Favorite button
                Positioned(
                  top: 10,
                  right: 10,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: AppColors.cream,
                      shape: BoxShape.circle,
                    ),
                    child: ValueListenableBuilder<List<ProductModel>>(
                      valueListenable: FavoriteService.favorites,
                      builder: (context, favorites, child) {
                        final isFavorite = favorites.any(
                          (item) => item.id == product.id,
                        );

                        return IconButton(
                          tooltip: isFavorite
                              ? 'Remove from favorites'
                              : 'Add to favorites',
                          onPressed: () {
                            FavoriteService.toggle(product);

                            ScaffoldMessenger.of(context)
                              ..hideCurrentSnackBar()
                              ..showSnackBar(
                                SnackBar(
                                  content: Text(
                                    isFavorite
                                        ? 'Removed from favorites'
                                        : 'Added to favorites 🤎',
                                  ),
                                  duration: const Duration(
                                    milliseconds: 1200,
                                  ),
                                  behavior: SnackBarBehavior.floating,
                                  backgroundColor: AppColors.chocolate,
                                ),
                              );
                          },
                          icon: Icon(
                            isFavorite
                                ? Icons.favorite_rounded
                                : Icons.favorite_border_rounded,
                            size: 20,
                            color: isFavorite
                                ? AppColors.caramel
                                : AppColors.chocolate,
                          ),
                        );
                      },
                    ),
                  ),
                ),

                // Popular badge
                if (product.isPopular)
                  Positioned(
                    top: 10,
                    left: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 9,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.cream,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'Popular',
                        style: textTheme.labelSmall?.copyWith(
                          color: AppColors.chocolate,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // Product information
          Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(11, 10, 11, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.titleSmall,
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      const Icon(
                        Icons.star_rounded,
                        size: 15,
                        color: AppColors.caramel,
                      ),
                      const SizedBox(width: 3),
                      Text(
                        product.rating.toString(),
                        style: textTheme.bodySmall,
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: product.stock == 0
                              ? AppColors.error.withValues(alpha: 0.12)
                              : AppColors.chocolate.withValues(alpha: 0.10),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          product.stock > 0 ? 'Stok: ${product.stock}' : 'Habis',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: product.stock == 0
                                ? AppColors.error
                                : AppColors.chocolate,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          formattedPrice,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: textTheme.titleSmall?.copyWith(
                            color: AppColors.chocolate,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Material(
                        color: product.stock > 0
                            ? AppColors.chocolate
                            : Colors.grey.shade400,
                        borderRadius: BorderRadius.circular(11),
                        child: InkWell(
                          onTap: product.stock > 0 ? onAdd : null,
                          borderRadius: BorderRadius.circular(11),
                          child: const SizedBox(
                            width: 32,
                            height: 32,
                            child: Icon(
                              Icons.add_rounded,
                              color: Colors.white,
                              size: 21,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
    );
  }
}
