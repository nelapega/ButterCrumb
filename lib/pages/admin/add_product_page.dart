
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/constants/app_colors.dart';
import '../../models/category_model.dart';
import '../../models/product_model.dart';
import '../../services/category_service.dart';
import '../../services/product_service.dart';

class AddProductPage extends StatefulWidget {
  const AddProductPage({super.key});

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _stockController = TextEditingController(text: '10');
  final _descriptionController = TextEditingController();
  final _imageController = TextEditingController();

  String _selectedCategory = 'Cake';
  bool _isPopular = false;
  bool _isSaving = false;

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    _descriptionController.dispose();
    _imageController.dispose();
    super.dispose();
  }

  void _showMessage(String message, {bool isError = false}) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor:
              isError ? AppColors.error : AppColors.chocolate,
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  void _saveProduct() {
    if (_isSaving) return;

    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) return;

    final categories = CategoryService.getAllCategories();

    if (categories.isEmpty) {
      _showMessage(
        'Belum ada kategori. Tambahkan kategori terlebih dahulu.',
        isError: true,
      );
      return;
    }

    final categoryExists = categories.any(
      (category) => category.name == _selectedCategory,
    );

    final categoryName = categoryExists
        ? _selectedCategory
        : categories.first.name;

    final price = double.tryParse(_priceController.text.trim());
    final stock = int.tryParse(_stockController.text.trim());

    if (price == null || price <= 0) {
      _showMessage(
        'Masukkan harga produk yang valid.',
        isError: true,
      );
      return;
    }

    if (stock == null || stock < 0) {
      _showMessage(
        'Stok harus berupa bilangan bulat nol atau lebih.',
        isError: true,
      );
      return;
    }

    setState(() => _isSaving = true);

    try {
      final product = ProductModel(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        name: _nameController.text.trim(),
        category: categoryName,
        description: _descriptionController.text.trim(),
        image: _imageController.text.trim(),
        price: price,
        rating: 4.8,
        isPopular: _isPopular,
        stock: stock,
      );

      ProductService.addProduct(product);

      if (!mounted) return;

      _showMessage('Produk berhasil ditambahkan! 🍰');
      Navigator.pop(context, true);
    } catch (error) {
      _showMessage(
        'Gagal menyimpan produk: $error',
        isError: true,
      );

      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  String? _validateImageUrl(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'URL gambar wajib diisi.';
    }

    final uri = Uri.tryParse(value.trim());

    if (uri == null ||
        !uri.hasAuthority ||
        (uri.scheme != 'http' && uri.scheme != 'https')) {
      return 'Masukkan URL gambar yang valid.';
    }

    return null;
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppColors.darkBrown,
        ),
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String hint,
    Widget? prefixIcon,
  }) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: prefixIcon,
      filled: true,
      fillColor: AppColors.cream,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 15,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: AppColors.divider),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: AppColors.divider),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(
          color: AppColors.chocolate,
          width: 1.5,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: AppColors.error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(
          color: AppColors.error,
          width: 1.5,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Tambah Produk',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.darkBrown,
        elevation: 0,
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 30),
            children: [
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: AppColors.softPink,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.cake_rounded,
                      size: 36,
                      color: AppColors.chocolate,
                    ),
                    SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Produk Baru 🍰',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.darkBrown,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            'Lengkapi informasi produk bakery kamu.',
                            style: TextStyle(
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

              const SizedBox(height: 26),

              _buildLabel('Nama Produk'),
              TextFormField(
                controller: _nameController,
                textCapitalization: TextCapitalization.words,
                decoration: _inputDecoration(
                  hint: 'Contoh: Chocolate Cake',
                  prefixIcon: const Icon(
                    Icons.cake_outlined,
                    color: AppColors.mocha,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Nama produk wajib diisi.';
                  }
                  if (value.trim().length < 3) {
                    return 'Nama produk minimal 3 karakter.';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20),

              _buildLabel('Kategori'),
              ValueListenableBuilder<List<CategoryModel>>(
                valueListenable: CategoryService.categories,
                builder: (context, categories, child) {
                  final categoryNames = categories
                      .map((category) => category.name)
                      .toList();

                  final selectedCategory =
                      categoryNames.contains(_selectedCategory)
                          ? _selectedCategory
                          : categoryNames.isNotEmpty
                              ? categoryNames.first
                              : null;

                  if (categoryNames.isEmpty) {
                    return Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.softCream,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: AppColors.divider,
                        ),
                      ),
                      child: const Text(
                        'Belum ada kategori. Tambahkan kategori '
                        'melalui menu Kelola Kategori.',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    );
                  }

                  return DropdownButtonFormField<String>(
                    initialValue: selectedCategory,
                    decoration: _inputDecoration(
                      hint: 'Pilih kategori',
                      prefixIcon: const Icon(
                        Icons.category_outlined,
                        color: AppColors.mocha,
                      ),
                    ),
                    borderRadius: BorderRadius.circular(15),
                    items: categoryNames.map((category) {
                      return DropdownMenuItem<String>(
                        value: category,
                        child: Text(category),
                      );
                    }).toList(),
                    onChanged: _isSaving
                        ? null
                        : (value) {
                            if (value != null) {
                              setState(() {
                                _selectedCategory = value;
                              });
                            }
                          },
                  );
                },
              ),

              const SizedBox(height: 20),

              _buildLabel('Harga Produk (Rupiah)'),
              TextFormField(
                controller: _priceController,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                decoration: _inputDecoration(
                  hint: 'Contoh: 85000',
                  prefixIcon: const Padding(
                    padding: EdgeInsets.all(15),
                    child: Text(
                      'Rp',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.chocolate,
                      ),
                    ),
                  ),
                ),
                validator: (value) {
                  final price = double.tryParse(value?.trim() ?? '');
                  if (price == null || price <= 0) {
                    return 'Harga harus lebih dari nol.';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20),

              // Input stok awal produk.
              _buildLabel('Stok Awal Produk'),
              TextFormField(
                controller: _stockController,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                decoration: _inputDecoration(
                  hint: 'Contoh: 20',
                  prefixIcon: const Icon(
                    Icons.inventory_2_outlined,
                    color: AppColors.mocha,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Stok awal wajib diisi.';
                  }

                  final stock = int.tryParse(value.trim());

                  if (stock == null || stock < 0) {
                    return 'Stok harus nol atau lebih.';
                  }

                  return null;
                },
              ),
              const SizedBox(height: 6),
              const Text(
                'Masukkan jumlah barang yang tersedia. Stok dapat '
                'diubah kembali melalui menu Edit Produk.',
                style: TextStyle(
                  fontSize: 11,
                  color: AppColors.textSecondary,
                ),
              ),

              const SizedBox(height: 20),

              _buildLabel('Deskripsi Produk'),
              TextFormField(
                controller: _descriptionController,
                minLines: 3,
                maxLines: 5,
                textCapitalization: TextCapitalization.sentences,
                decoration: _inputDecoration(
                  hint: 'Ceritakan rasa dan keistimewaan produk...',
                  prefixIcon: const Padding(
                    padding: EdgeInsets.only(bottom: 65),
                    child: Icon(
                      Icons.description_outlined,
                      color: AppColors.mocha,
                    ),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Deskripsi produk wajib diisi.';
                  }
                  if (value.trim().length < 10) {
                    return 'Deskripsi minimal 10 karakter.';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20),

              _buildLabel('URL Gambar Produk'),
              TextFormField(
                controller: _imageController,
                keyboardType: TextInputType.url,
                onChanged: (_) => setState(() {}),
                decoration: _inputDecoration(
                  hint: 'https://contoh.com/gambar.jpg',
                  prefixIcon: const Icon(
                    Icons.image_outlined,
                    color: AppColors.mocha,
                  ),
                ),
                validator: _validateImageUrl,
              ),

              const SizedBox(height: 12),

              if (_imageController.text.trim().isNotEmpty &&
                  _validateImageUrl(_imageController.text) == null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    _imageController.text.trim(),
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) {
                      return Container(
                        height: 120,
                        alignment: Alignment.center,
                        color: AppColors.softCream,
                        child: const Text(
                          'Gambar tidak dapat ditampilkan.',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      );
                    },
                  ),
                ),

              const SizedBox(height: 20),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: AppColors.cream,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.divider),
                ),
                child: CheckboxListTile(
                  value: _isPopular,
                  onChanged: _isSaving
                      ? null
                      : (value) {
                          setState(() {
                            _isPopular = value ?? false;
                          });
                        },
                  contentPadding: EdgeInsets.zero,
                  activeColor: AppColors.chocolate,
                  controlAffinity: ListTileControlAffinity.leading,
                  secondary: const Icon(
                    Icons.local_fire_department_rounded,
                    color: AppColors.mocha,
                  ),
                  title: const Text(
                    'Produk Populer',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.darkBrown,
                    ),
                  ),
                  subtitle: const Text(
                    'Tandai sebagai produk unggulan.',
                    style: TextStyle(
                      fontSize: 11,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              SizedBox(
                height: 54,
                child: ElevatedButton.icon(
                  onPressed: _isSaving ? null : _saveProduct,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.chocolate,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: AppColors.mocha,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  icon: _isSaving
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.save_outlined),
                  label: Text(
                    _isSaving ? 'Menyimpan...' : 'Simpan Produk',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              SizedBox(
                height: 50,
                child: OutlinedButton(
                  onPressed: _isSaving
                      ? null
                      : () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.chocolate,
                    side: const BorderSide(
                      color: AppColors.divider,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text('Batal'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
