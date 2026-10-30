
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/constants/app_colors.dart';
import '../../models/product_model.dart';
import '../../services/product_service.dart';

class EditProductPage extends StatefulWidget {
  final ProductModel product;

  const EditProductPage({
    super.key,
    required this.product,
  });

  @override
  State<EditProductPage> createState() => _EditProductPageState();
}

class _EditProductPageState extends State<EditProductPage> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _priceController;
  late final TextEditingController _stockController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _imageController;

  late String _selectedCategory;
  late bool _isPopular;

  bool _isSaving = false;

  final List<String> _categories = const [
    'Cake',
    'Pastry',
    'Cookies',
    'Cupcake',
  ];

  @override
  void initState() {
    super.initState();

    final product = widget.product;

    _nameController = TextEditingController(text: product.name);
    _priceController = TextEditingController(
      text: product.price.toStringAsFixed(0),
    );
    _stockController = TextEditingController(
      text: product.stock.toString(),
    );
    _descriptionController = TextEditingController(
      text: product.description,
    );
    _imageController = TextEditingController(text: product.image);

    _selectedCategory = _categories.contains(product.category)
        ? product.category
        : _categories.first;

    _isPopular = product.isPopular;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    _descriptionController.dispose();
    _imageController.dispose();
    super.dispose();
  }

  void _saveProduct() {
    if (_isSaving || !_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    final updatedProduct = widget.product.copyWith(
      name: _nameController.text.trim(),
      category: _selectedCategory,
      description: _descriptionController.text.trim(),
      image: _imageController.text.trim(),
      price: double.parse(_priceController.text.trim()),
      stock: int.parse(_stockController.text.trim()),
      isPopular: _isPopular,
    );

    final success = ProductService.updateProduct(updatedProduct);

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Produk dan stok berhasil diperbarui! 🍰'),
          backgroundColor: AppColors.success,
        ),
      );
      Navigator.pop(context, true);
    } else {
      setState(() => _isSaving = false);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Produk tidak ditemukan.'),
          backgroundColor: AppColors.error,
        ),
      );
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

  InputDecoration _decoration(String hint, {Widget? icon}) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: icon,
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
    );
  }

  Widget _label(String text) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Edit Produk',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.darkBrown,
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 30),
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
                      Icons.inventory_2_rounded,
                      size: 36,
                      color: AppColors.chocolate,
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Perbarui Produk dan Stok 🍰',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: AppColors.darkBrown,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              _label('Nama Produk'),
              TextFormField(
                controller: _nameController,
                validator: (value) {
                  if (value == null || value.trim().length < 3) {
                    return 'Nama minimal 3 karakter.';
                  }
                  return null;
                },
                decoration: _decoration(
                  'Nama produk',
                  icon: const Icon(Icons.cake_outlined),
                ),
              ),
              const SizedBox(height: 18),

              _label('Kategori'),
              DropdownButtonFormField<String>(
                initialValue: _selectedCategory,
                decoration: _decoration('Pilih kategori'),
                items: _categories.map((category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _selectedCategory = value);
                  }
                },
              ),
              const SizedBox(height: 18),

              _label('Harga Produk (Rupiah)'),
              TextFormField(
                controller: _priceController,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                decoration: _decoration(
                  'Contoh: 85000',
                  icon: const Icon(Icons.payments_outlined),
                ),
                validator: (value) {
                  final price = double.tryParse(value ?? '');
                  if (price == null || price <= 0) {
                    return 'Harga harus lebih dari nol.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 18),

              _label('Stok Produk'),
              TextFormField(
                controller: _stockController,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                decoration: _decoration(
                  'Masukkan jumlah stok',
                  icon: const Icon(Icons.inventory_2_outlined),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Stok wajib diisi.';
                  }

                  if (int.tryParse(value.trim()) == null) {
                    return 'Masukkan jumlah stok yang valid.';
                  }

                  return null;
                },
              ),
              const SizedBox(height: 8),
              Text(
                'Stok saat ini: ${widget.product.stock} buah',
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 18),

              _label('Deskripsi Produk'),
              TextFormField(
                controller: _descriptionController,
                minLines: 3,
                maxLines: 5,
                decoration: _decoration('Deskripsi produk'),
                validator: (value) {
                  if (value == null || value.trim().length < 10) {
                    return 'Deskripsi minimal 10 karakter.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 18),

              _label('URL Gambar Produk'),
              TextFormField(
                controller: _imageController,
                keyboardType: TextInputType.url,
                decoration: _decoration(
                  'https://contoh.com/gambar.jpg',
                  icon: const Icon(Icons.image_outlined),
                ),
                validator: _validateImageUrl,
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 12),

              if (_validateImageUrl(_imageController.text) == null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.network(
                    _imageController.text.trim(),
                    height: 170,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const SizedBox(
                      height: 70,
                      child: Center(
                        child: Text('Pratinjau gambar tidak tersedia.'),
                      ),
                    ),
                  ),
                ),
              const SizedBox(height: 18),

              CheckboxListTile(
                value: _isPopular,
                onChanged: (value) {
                  setState(() => _isPopular = value ?? false);
                },
                contentPadding: EdgeInsets.zero,
                activeColor: AppColors.chocolate,
                title: const Text('Produk Populer'),
                secondary: const Icon(
                  Icons.local_fire_department_rounded,
                  color: AppColors.mocha,
                ),
              ),
              const SizedBox(height: 24),

              SizedBox(
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: _isSaving ? null : _saveProduct,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.chocolate,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  icon: const Icon(Icons.save_outlined),
                  label: Text(
                    _isSaving ? 'Menyimpan...' : 'Simpan Perubahan',
                  ),
                ),
              ),
              const SizedBox(height: 10),

              OutlinedButton(
                onPressed: _isSaving
                    ? null
                    : () => Navigator.pop(context),
                child: const Text('Batal'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
