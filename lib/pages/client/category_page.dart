
import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../models/category_model.dart';
import '../../models/product_model.dart';
import '../../services/category_service.dart';
import '../../services/cart_service.dart';
import '../../services/product_service.dart';
import '../../widgets/product_card.dart';
import 'product_detail_page.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  String _selectedCategory = 'All';

  void _openProduct(ProductModel product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ProductDetailPage(product: product),
      ),
    );
  }

  void _addToCart(ProductModel product) {
    CartService.add(product);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product.name} ditambahkan ke keranjang 🤎'),
        backgroundColor: AppColors.chocolate,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Explore Categories',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.darkBrown,
          ),
        ),
      ),
      body: SafeArea(
        child: ValueListenableBuilder<List<CategoryModel>>(
          valueListenable: CategoryService.categories,
          builder: (context, categories, child) {
            final categoryNames = [
              'All',
              ...categories
                  .map((category) => category.name)
                  .where((name) => name.toLowerCase() != 'all'),
            ];

            if (!categoryNames.contains(_selectedCategory)) {
              _selectedCategory = 'All';
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(20, 8, 20, 4),
                  child: Text(
                    'Find Your Sweet Treat 🍰',
                    style: TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                      color: AppColors.darkBrown,
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    'Pilih kategori favoritmu dan temukan camilan lezat.',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                SizedBox(
                  height: 44,
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    scrollDirection: Axis.horizontal,
                    itemCount: categoryNames.length,
                    separatorBuilder: (_, _) =>
                        const SizedBox(width: 10),
                    itemBuilder: (context, index) {
                      final category = categoryNames[index];
                      final selected = category == _selectedCategory;

                      return ChoiceChip(
                        label: Text(category),
                        selected: selected,
                        onSelected: (_) {
                          setState(() {
                            _selectedCategory = category;
                          });
                        },
                        selectedColor: AppColors.chocolate,
                        backgroundColor: AppColors.cream,
                        labelStyle: TextStyle(
                          color: selected
                              ? Colors.white
                              : AppColors.chocolate,
                          fontWeight: FontWeight.w600,
                        ),
                        side: BorderSide(
                          color: selected
                              ? AppColors.chocolate
                              : AppColors.divider,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(22),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 20),

                Expanded(
                  child: ValueListenableBuilder<List<ProductModel>>(
                    valueListenable: ProductService.products,
                    builder: (context, products, child) {
                      final filteredProducts =
                          _selectedCategory.toLowerCase() == 'all'
                              ? products
                              : products
                                  .where(
                                    (product) =>
                                        product.category.toLowerCase() ==
                                        _selectedCategory.toLowerCase(),
                                  )
                                  .toList();

                      if (filteredProducts.isEmpty) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.cake_outlined,
                                  size: 64,
                                  color: AppColors.caramel,
                                ),
                                const SizedBox(height: 14),
                                const Text(
                                  'Belum Ada Produk',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.darkBrown,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Belum ada produk untuk kategori '
                                  '$_selectedCategory.',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }

                      return GridView.builder(
                        padding: const EdgeInsets.fromLTRB(
                          16, 0, 16, 24,
                        ),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 0.62,
                        ),
                        itemCount: filteredProducts.length,
                        itemBuilder: (context, index) {
                          final product = filteredProducts[index];

                          return ProductCard(
                            product: product,
                            onTap: () => _openProduct(product),
                            onAdd: () => _addToCart(product),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
