
import 'package:butter_crumb/pages/admin/admin_products_page.dart';
import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import 'admin_dashboard_page.dart';
import 'admin_orders_page.dart';
import 'admin_profile_page.dart';
import '../auth/role_selection_page.dart';

class AdminMainPage extends StatefulWidget {
  final String adminName;
  final String adminEmail;

  const AdminMainPage({
    super.key,
    this.adminName = 'Admin',
    this.adminEmail = 'admin@buttercrumb.com',
  });

  @override
  State<AdminMainPage> createState() => _AdminMainPageState();
}

class _AdminMainPageState extends State<AdminMainPage> {
  int _currentIndex = 0;

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();

    _pages = [
      const AdminDashboardPage(),
      const AdminProductPage(),
      const AdminOrdersPage(),
      AdminProfilePage(
        adminName: widget.adminName,
        adminEmail: widget.adminEmail,
      ),
    ];
  }

  final List<NavigationDestination> _destinations = const [
    NavigationDestination(
      icon: Icon(Icons.dashboard_outlined),
      selectedIcon: Icon(Icons.dashboard),
      label: 'Dashboard',
    ),
    NavigationDestination(
      icon: Icon(Icons.inventory_2_outlined),
      selectedIcon: Icon(Icons.inventory_2),
      label: 'Produk',
    ),
    NavigationDestination(
      icon: Icon(Icons.receipt_long_outlined),
      selectedIcon: Icon(Icons.receipt_long),
      label: 'Pesanan',
    ),
    NavigationDestination(
      icon: Icon(Icons.person_outline),
      selectedIcon: Icon(Icons.person),
      label: 'Profil',
    ),
  ];

  // LOGOUT ADMIN
  void _logout() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (_) => const RoleSelectionPage(),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: SafeArea(
          child: IndexedStack(
            index: _currentIndex,
            children: _pages,
          ),
        ),
        bottomNavigationBar: NavigationBar(
          selectedIndex: _currentIndex,
          onDestinationSelected: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          backgroundColor: AppColors.cream,
          indicatorColor: AppColors.softPink,
          elevation: 0,
          destinations: _destinations,
        ),
      ),
    );
  }
}
