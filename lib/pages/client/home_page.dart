import 'package:butter_crumb/pages/client/favorite_page.dart';
import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../models/product_model.dart';
import '../../models/order_model.dart';
import '../../services/cart_service.dart';
import '../../services/order_service.dart';
import '../../services/favorite_service.dart';
import '../../services/category_service.dart';
import '../../services/product_service.dart';
import '../../widgets/product_card.dart';
import '../auth/role_selection_page.dart';
import 'cart_page.dart';
import 'product_detail_page.dart';
import 'profile_page.dart';

class HomePage extends StatefulWidget {
  final String clientName;
  final String clientEmail;

  const HomePage({
    super.key,
    required this.clientName,
    required this.clientEmail,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  String _selectedCategory = 'All';
  String _searchQuery = '';

  final TextEditingController _searchController = TextEditingController();

  // Kategori dibaca dari satu sumber bersama agar kategori baru
  // yang ditambahkan admin langsung muncul di halaman pelanggan.
  List<String> get _categories => [
    'All',
    ...CategoryService.getAllCategories().map((category) => category.name),
  ];

  @override
  void initState() {
    super.initState();
    CartService.items.addListener(_refreshCart);
    ProductService.products.addListener(_refreshCatalog);
    CategoryService.categories.addListener(_refreshCatalog);
  }

  @override
  void dispose() {
    CartService.items.removeListener(_refreshCart);
    ProductService.products.removeListener(_refreshCatalog);
    CategoryService.categories.removeListener(_refreshCatalog);
    _searchController.dispose();
    super.dispose();
  }

  void _refreshCart() {
    if (mounted) {
      setState(() {});
    }
  }

  void _refreshCatalog() {
    if (!mounted) return;

    final categories = _categories;

    setState(() {
      // Jika kategori yang dipilih dihapus admin, kembali ke All.
      if (!categories.contains(_selectedCategory)) {
        _selectedCategory = 'All';
      }
    });
  }

  List<ProductModel> get _filteredProducts {
    return ProductService.getAllProducts().where((product) {
      final matchesCategory =
          _selectedCategory == 'All' ||
          product.category.toLowerCase() == _selectedCategory.toLowerCase();

      final matchesSearch = product.name.toLowerCase().contains(
        _searchQuery.toLowerCase(),
      );

      return matchesCategory && matchesSearch;
    }).toList();
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

  void _openProduct(ProductModel product) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => ProductDetailPage(product: product)),
    );
  }

  void _openFavorites() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const FavoritesPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      _buildHome(),
      const CartPage(),
      _buildOrders(),
      ProfilePage(clientEmail: widget.clientEmail, onLogout: _logout),
    ];

    return Scaffold(
      backgroundColor: AppColors.softCream,
      body: SafeArea(
        child: IndexedStack(index: _selectedIndex, children: pages),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        backgroundColor: AppColors.cream,
        indicatorColor: AppColors.softPink,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: [
          const NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          NavigationDestination(
            icon: _cartIcon(false),
            selectedIcon: _cartIcon(true),
            label: 'Cart',
          ),
          const NavigationDestination(
            icon: Icon(Icons.receipt_long_outlined),
            selectedIcon: Icon(Icons.receipt_long_rounded),
            label: 'Orders',
          ),
          const NavigationDestination(
            icon: Icon(Icons.person_outline_rounded),
            selectedIcon: Icon(Icons.person_rounded),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _cartIcon(bool selected) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Icon(
          selected ? Icons.shopping_bag_rounded : Icons.shopping_bag_outlined,
        ),
        if (CartService.count > 0)
          Positioned(
            right: -8,
            top: -7,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: Color(0xFFB76E52),
                shape: BoxShape.circle,
              ),
              constraints: const BoxConstraints(minWidth: 17, minHeight: 17),
              child: Text(
                '${CartService.count}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
      ],
    );
  }

  // =========================
  // HOME PAGE
  // =========================

  Widget _buildHome() {
    final products = _filteredProducts;

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 22, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // HEADER
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'BUTTER & CRUMB',
                            style: TextStyle(
                              color: AppColors.mocha,
                              fontSize: 11,
                              letterSpacing: 2.5,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Hi, ${widget.clientName} 👋',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: AppColors.chocolate,
                              fontSize: 23,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'What sweet treat do you crave today?',
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),

                    // FAVORITES BUTTON + COUNT
                    ValueListenableBuilder<List<ProductModel>>(
                      valueListenable: FavoriteService.favorites,
                      builder: (context, favorites, child) {
                        return InkWell(
                          onTap: _openFavorites,
                          borderRadius: BorderRadius.circular(16),
                          child: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: AppColors.softPink,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Stack(
                              clipBehavior: Clip.none,
                              alignment: Alignment.center,
                              children: [
                                const Icon(
                                  Icons.favorite_rounded,
                                  color: AppColors.chocolate,
                                  size: 27,
                                ),
                                if (favorites.isNotEmpty)
                                  Positioned(
                                    top: -5,
                                    right: -5,
                                    child: Container(
                                      constraints: const BoxConstraints(
                                        minWidth: 19,
                                        minHeight: 19,
                                      ),
                                      padding: const EdgeInsets.all(3),
                                      decoration: const BoxDecoration(
                                        color: AppColors.caramel,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Text(
                                        favorites.length > 99
                                            ? '99+'
                                            : '${favorites.length}',
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 9,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // SEARCH
                TextField(
                  controller: _searchController,
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Search cakes, cookies, pastries...',
                    hintStyle: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                    prefixIcon: Icon(
                      Icons.search_rounded,
                      color: AppColors.mocha,
                    ),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            onPressed: () {
                              _searchController.clear();
                              setState(() {
                                _searchQuery = '';
                              });
                            },
                            icon: const Icon(Icons.close),
                          )
                        : null,
                    filled: true,
                    fillColor: AppColors.cream,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(17),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(17),
                      borderSide: BorderSide(color: AppColors.divider),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // PROMO BANNER
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    color: AppColors.chocolate,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'MADE WITH LOVE 🤎',
                              style: TextStyle(
                                color: Color(0xFFEBD2B9),
                                fontSize: 10,
                                letterSpacing: 1.5,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'A little sweetness\nmakes a big difference.',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 19,
                                height: 1.35,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 14),
                            const Text(
                              'Discover your new favorite treat.',
                              style: TextStyle(
                                color: Color(0xFFEBD2B9),
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(
                        Icons.bakery_dining_rounded,
                        color: Color(0xFFEBD2B9),
                        size: 72,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 28),

                // CATEGORY TITLE
                Text(
                  'Categories',
                  style: TextStyle(
                    color: AppColors.chocolate,
                    fontSize: 19,
                    fontWeight: FontWeight.w800,
                  ),
                ),

                const SizedBox(height: 14),

                // CATEGORY FILTER
                SizedBox(
                  height: 42,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: _categories.length,
                    separatorBuilder: (_, index) => const SizedBox(width: 9),
                    itemBuilder: (context, index) {
                      final category = _categories[index];
                      final isSelected = _selectedCategory == category;

                      return ChoiceChip(
                        label: Text(category),
                        selected: isSelected,
                        onSelected: (_) {
                          setState(() {
                            _selectedCategory = category;
                          });
                        },
                        selectedColor: AppColors.chocolate,
                        backgroundColor: AppColors.cream,
                        labelStyle: TextStyle(
                          color: isSelected
                              ? Colors.white
                              : AppColors.chocolate,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                        side: BorderSide.none,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 26),

                // PRODUCT TITLE
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        _searchQuery.isNotEmpty
                            ? 'Search Results'
                            : _selectedCategory == 'All'
                            ? 'Our Sweet Treats'
                            : _selectedCategory,
                        style: TextStyle(
                          color: AppColors.chocolate,
                          fontSize: 19,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    Text(
                      '${products.length} items',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),
              ],
            ),
          ),
        ),

        // PRODUCT GRID
        if (products.isEmpty)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(35),
              child: Column(
                children: [
                  Icon(
                    Icons.search_off_rounded,
                    size: 55,
                    color: AppColors.mocha,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'No treats found',
                    style: TextStyle(
                      color: AppColors.chocolate,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Try another keyword or category.',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          )
        else
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 14,
                mainAxisSpacing: 16,
                childAspectRatio: 0.61,
              ),
              delegate: SliverChildBuilderDelegate((context, index) {
                final product = products[index];

                return GestureDetector(
                  onTap: () => _openProduct(product),
                  child: ProductCard(
                    product: product,
                    onAdd: () => _addToCart(product),
                  ),
                );
              }, childCount: products.length),
            ),
          ),
      ],
    );
  }

  // =========================
  // ORDER HISTORY
  // =========================

  Widget _buildOrders() {
    return ValueListenableBuilder<List<OrderModel>>(
      valueListenable: OrderService.orders,
      builder: (context, orders, child) {
        if (orders.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(28),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.receipt_long_rounded,
                    size: 68,
                    color: AppColors.mocha,
                  ),
                  const SizedBox(height: 18),
                  Text(
                    'No orders yet',
                    style: TextStyle(
                      color: AppColors.chocolate,
                      fontSize: 23,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Your sweet orders will appear here.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _selectedIndex = 0;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.chocolate,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Explore Treats'),
                  ),
                ],
              ),
            ),
          );
        }

        return ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text(
              'My Orders',
              style: TextStyle(
                color: AppColors.chocolate,
                fontSize: 25,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              '${orders.length} order(s) placed',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
            ),
            const SizedBox(height: 20),
            ...orders.map((order) {
              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: AppColors.cream,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.divider),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            '#${order.orderNumber}',
                            style: TextStyle(
                              color: AppColors.chocolate,
                              fontWeight: FontWeight.w800,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.softPink,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            order.status,
                            style: TextStyle(
                              color: AppColors.chocolate,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${order.createdAt.day}/'
                      '${order.createdAt.month}/'
                      '${order.createdAt.year}',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                    const Divider(height: 24),
                    ...order.items.map((item) {
                      final name = item['name']?.toString() ?? 'Product';
                      final quantity = item['quantity'] as int? ?? 0;
                      final price = (item['price'] as num?)?.toDouble() ?? 0.0;

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                '$name × $quantity',
                                style: TextStyle(
                                  color: AppColors.chocolate,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                            Text(
                              _orderRupiah(price * quantity),
                              style: TextStyle(
                                color: AppColors.chocolate,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                    const Divider(height: 24),
                    Text(
                      'Delivery: ${order.delivery}',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Payment: ${order.payment}',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Total',
                            style: TextStyle(
                              color: AppColors.chocolate,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        Text(
                          _orderRupiah(order.total),
                          style: TextStyle(
                            color: AppColors.chocolate,
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }),
          ],
        );
      },
    );
  }

  String _orderRupiah(double value) {
    final formatted = value.toInt().toString().replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (_) => '.',
    );
    return 'Rp $formatted';
  }

  // =========================
  // LOGOUT
  // =========================

  void _logout() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const RoleSelectionPage()),
      (route) => false,
    );
  }
}
