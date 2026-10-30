
import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../models/product_model.dart';
import '../../services/product_service.dart';
import 'add_product_page.dart';
import 'edit_product_page.dart';

class AdminProductPage extends StatefulWidget {
  const AdminProductPage({super.key});

  @override
  State<AdminProductPage> createState() => _AdminProductPageState();
}

class _AdminProductPageState extends State<AdminProductPage> {
  final TextEditingController _searchController = TextEditingController();

  String _selectedCategory = 'All';
  String _searchQuery = '';

  final List<String> _categories = const [
    'All',
    'Cake',
    'Pastry',
    'Cookies',
    'Cupcake',
  ];

  List<ProductModel> _filterProducts(List<ProductModel> products) {
    final query = _searchQuery.trim().toLowerCase();

    return products.where((product) {
      final matchesCategory = _selectedCategory == 'All' ||
          product.category.toLowerCase() ==
              _selectedCategory.toLowerCase();

      final matchesSearch = product.name.toLowerCase().contains(query) ||
          product.category.toLowerCase().contains(query);

      return matchesCategory && matchesSearch;
    }).toList();
  }

  Future<void> _openAddProduct() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const AddProductPage(),
      ),
    );
  }

  Future<void> _openEditProduct(ProductModel product) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EditProductPage(product: product),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openAddProduct,
        backgroundColor: AppColors.chocolate,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text(
          'Tambah Produk',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 22, 20, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(
                        Icons.inventory_2_rounded,
                        color: AppColors.chocolate,
                        size: 28,
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Kelola Produk',
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
                    'Atur katalog, harga, dan stok produk bakery.',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 20),

                  TextField(
                    controller: _searchController,
                    onChanged: (value) {
                      setState(() => _searchQuery = value);
                    },
                    decoration: InputDecoration(
                      hintText: 'Cari nama produk...',
                      prefixIcon: const Icon(
                        Icons.search,
                        color: AppColors.mocha,
                      ),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                              onPressed: () {
                                _searchController.clear();
                                setState(() => _searchQuery = '');
                              },
                              icon: const Icon(Icons.close),
                            )
                          : null,
                      filled: true,
                      fillColor: AppColors.cream,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide:
                            const BorderSide(color: AppColors.divider),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide:
                            const BorderSide(color: AppColors.divider),
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
                  const SizedBox(height: 18),

                  SizedBox(
                    height: 40,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: _categories.length,
                      separatorBuilder: (_, _) =>
                          const SizedBox(width: 8),
                      itemBuilder: (context, index) {
                        final category = _categories[index];
                        final selected = _selectedCategory == category;

                        return ChoiceChip(
                          label: Text(category),
                          selected: selected,
                          onSelected: (_) {
                            setState(() => _selectedCategory = category);
                          },
                          selectedColor: AppColors.chocolate,
                          backgroundColor: AppColors.cream,
                          labelStyle: TextStyle(
                            color: selected
                                ? Colors.white
                                : AppColors.chocolate,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                          side: BorderSide(
                            color: selected
                                ? AppColors.chocolate
                                : AppColors.divider,
                          ),
                          showCheckmark: false,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 18),
                  const Text(
                    'Daftar Produk',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: AppColors.darkBrown,
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: ValueListenableBuilder<List<ProductModel>>(
                valueListenable: ProductService.products,
                builder: (context, allProducts, child) {
                  final products = _filterProducts(allProducts);

                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 4,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${products.length} produk',
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            Text(
                              'Total stok: ${allProducts.fold<int>(0, (sum, p) => sum + p.stock)}',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppColors.chocolate,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: products.isEmpty
                            ? _buildEmptyState()
                            : ListView.builder(
                                padding: const EdgeInsets.fromLTRB(
                                  20, 8, 20, 100,
                                ),
                                itemCount: products.length,
                                itemBuilder: (context, index) {
                                  final product = products[index];

                                  return _ProductAdminCard(
                                    product: product,
                                    onEdit: () => _openEditProduct(product),
                                  );
                                },
                              ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.search_off_rounded,
              size: 60,
              color: AppColors.mocha,
            ),
            SizedBox(height: 18),
            Text(
              'Produk tidak ditemukan',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.darkBrown,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Coba kata kunci atau kategori yang berbeda.',
              textAlign: TextAlign.center,
              style: TextStyle(
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

class _ProductAdminCard extends StatelessWidget {
  final ProductModel product;
  final VoidCallback onEdit;

  const _ProductAdminCard({
    required this.product,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final stockColor = product.stock == 0
        ? AppColors.error
        : product.stock <= 5
            ? const Color(0xFFB7791F)
            : AppColors.success;

    final stockLabel = product.stock == 0
        ? 'Stok Habis'
        : product.stock <= 5
            ? 'Stok Menipis'
            : 'Stok Tersedia';

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.cream,
        borderRadius: BorderRadius.circular(19),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Image.network(
              product.image,
              width: 82,
              height: 110,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => Container(
                width: 82,
                height: 110,
                color: AppColors.softCream,
                child: const Icon(
                  Icons.cake_outlined,
                  size: 34,
                  color: AppColors.mocha,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkBrown,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  product.category,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Rp ${product.price.toStringAsFixed(0)}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.chocolate,
                  ),
                ),
                const SizedBox(height: 7),
                Row(
                  children: [
                    Icon(
                      Icons.inventory_2_outlined,
                      size: 15,
                      color: stockColor,
                    ),
                    const SizedBox(width: 5),
                    Flexible(
                      child: Text(
                        'Stok: ${product.stock}',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: stockColor,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: stockColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    stockLabel,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: stockColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onEdit,
            tooltip: 'Edit produk dan stok',
            icon: const Icon(
              Icons.edit_outlined,
              color: AppColors.chocolate,
            ),
          ),
        ],
      ),
    );
  }
}
