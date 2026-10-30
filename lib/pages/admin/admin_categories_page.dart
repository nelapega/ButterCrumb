import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../models/category_model.dart';
import '../../services/category_service.dart';

class AdminCategoriesPage extends StatelessWidget {
  const AdminCategoriesPage({super.key});

  Future<void> _addCategory(BuildContext context) async {
    final controller = TextEditingController();

    final name = await showDialog<String>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: AppColors.cream,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          title: const Text(
            'Tambah Kategori',
            style: TextStyle(
              color: AppColors.darkBrown,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: TextField(
            controller: controller,
            autofocus: true,
            textCapitalization: TextCapitalization.words,
            decoration: InputDecoration(
              hintText: 'Contoh: Bread',
              prefixIcon: const Icon(
                Icons.category_outlined,
                color: AppColors.mocha,
              ),
              filled: true,
              fillColor: AppColors.background,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            onSubmitted: (value) {
              Navigator.pop(dialogContext, value.trim());
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text(
                'Batal',
                style: TextStyle(color: AppColors.textSecondary),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.chocolate,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                  controller.text.trim(),
                );
              },
              child: const Text('Tambah'),
            ),
          ],
        );
      },
    );

    controller.dispose();

    if (!context.mounted || name == null) return;

    final normalizedName = name.trim();

    if (normalizedName.isEmpty) {
      _showMessage(context, 'Nama kategori wajib diisi.');
      return;
    }

    if (normalizedName.toLowerCase() == 'all') {
      _showMessage(
        context,
        'Nama All dikhususkan untuk filter produk.',
      );
      return;
    }

    if (CategoryService.categoryExists(normalizedName)) {
      _showMessage(context, 'Kategori sudah tersedia.');
      return;
    }

    final category = CategoryModel(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      name: normalizedName,
    );

    final success = CategoryService.addCategory(category);

    if (success) {
      _showMessage(
        context,
        'Kategori "$normalizedName" berhasil ditambahkan.',
      );
    } else {
      _showMessage(context, 'Kategori gagal ditambahkan.');
    }
  }

  Future<void> _deleteCategory(
    BuildContext context,
    CategoryModel category,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: AppColors.cream,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          title: const Text(
            'Hapus Kategori?',
            style: TextStyle(
              color: AppColors.darkBrown,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            'Yakin ingin menghapus kategori "${category.name}"?',
            style: const TextStyle(
              color: AppColors.textSecondary,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: const Text(
                'Batal',
                style: TextStyle(color: AppColors.textSecondary),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.error,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              child: const Text('Hapus'),
            ),
          ],
        );
      },
    );

    if (!context.mounted || confirmed != true) return;

    final success = CategoryService.deleteCategory(category.id);

    _showMessage(
      context,
      success
          ? 'Kategori "${category.name}" berhasil dihapus.'
          : 'Kategori tidak ditemukan.',
    );
  }

  void _showMessage(BuildContext context, String message) {
    if (!context.mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: AppColors.chocolate,
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  IconData _getCategoryIcon(String name) {
    switch (name.toLowerCase()) {
      case 'cake':
        return Icons.cake_outlined;
      case 'pastry':
        return Icons.bakery_dining_outlined;
      case 'cookies':
        return Icons.cookie_outlined;
      case 'cupcake':
        return Icons.cake_rounded;
      case 'bread':
      case 'roti':
        return Icons.bakery_dining;
      default:
        return Icons.category_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Kategori Produk',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.darkBrown,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () => _addCategory(context),
            tooltip: 'Tambah kategori',
            icon: const Icon(Icons.add_circle_outline),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: ValueListenableBuilder(
          valueListenable: CategoryService.categories,
          builder: (context, categories, child) {
            return Column(
              children: [
                // Ringkasan kategori
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    20,
                    8,
                    20,
                    20,
                  ),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.softPink,
                      borderRadius: BorderRadius.circular(22),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 54,
                          height: 54,
                          decoration: BoxDecoration(
                            color: AppColors.cream,
                            borderRadius: BorderRadius.circular(17),
                          ),
                          child: const Icon(
                            Icons.category_rounded,
                            color: AppColors.chocolate,
                            size: 29,
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Kategori Bakery 🧁',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.darkBrown,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                '${categories.length} kategori tersedia',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Judul daftar kategori
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
                  child: Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'Daftar Kategori',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: AppColors.darkBrown,
                          ),
                        ),
                      ),
                      TextButton.icon(
                        onPressed: () => _addCategory(context),
                        icon: const Icon(Icons.add, size: 18),
                        label: const Text('Tambah'),
                        style: TextButton.styleFrom(
                          foregroundColor: AppColors.chocolate,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 8),

                // Daftar kategori
                Expanded(
                  child: categories.isEmpty
                      ? _buildEmptyState(context)
                      : ListView.separated(
                          padding: const EdgeInsets.fromLTRB(
                            20,
                            0,
                            20,
                            24,
                          ),
                          itemCount: categories.length,
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final category = categories[index];

                            return Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 13,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.cream,
                                borderRadius:
                                    BorderRadius.circular(18),
                                border: Border.all(
                                  color: AppColors.divider,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 48,
                                    height: 48,
                                    decoration: BoxDecoration(
                                      color: AppColors.softPink,
                                      borderRadius:
                                          BorderRadius.circular(15),
                                    ),
                                    child: Icon(
                                      _getCategoryIcon(category.name),
                                      color: AppColors.chocolate,
                                      size: 25,
                                    ),
                                  ),
                                  const SizedBox(width: 13),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          category.name,
                                          style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.darkBrown,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        const Text(
                                          'Kategori produk',
                                          style: TextStyle(
                                            fontSize: 11,
                                            color:
                                                AppColors.textSecondary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () => _deleteCategory(
                                      context,
                                      category,
                                    ),
                                    tooltip: 'Hapus kategori',
                                    icon: const Icon(
                                      Icons.delete_outline_rounded,
                                      color: AppColors.error,
                                    ),
                                  ),
                                ],
                              ),
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

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.category_outlined,
              size: 60,
              color: AppColors.caramel,
            ),
            const SizedBox(height: 14),
            const Text(
              'Belum Ada Kategori',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: AppColors.darkBrown,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Tambahkan kategori baru untuk katalog toko.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () => _addCategory(context),
              icon: const Icon(Icons.add),
              label: const Text('Tambah Kategori'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.chocolate,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}