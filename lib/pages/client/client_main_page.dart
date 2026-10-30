
import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../auth/login_page.dart';
import 'home_page.dart';
import 'category_page.dart';
import 'cart_page.dart';
import 'favorite_page.dart';
import 'profile_page.dart';

class ClientMainPage extends StatefulWidget {
  final String clientName;
  final String clientEmail;

  const ClientMainPage({
    super.key,
    required this.clientName,
    required this.clientEmail,
  });

  @override
  State<ClientMainPage> createState() => _ClientMainPageState();
}

class _ClientMainPageState extends State<ClientMainPage> {
  int _currentIndex = 0;

  void _logout() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginPage(role: 'Client')),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomePage(
        clientName: widget.clientName,
        clientEmail: widget.clientEmail,
      ),
      const CategoryPage(),
      const CartPage(),
      const FavoritesPage(),
      ProfilePage(
        clientEmail: widget.clientEmail,
        onLogout: _logout,
      ),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: pages,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        backgroundColor: AppColors.cream,
        indicatorColor: AppColors.softPink,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.grid_view_rounded),
            label: 'Kategori',
          ),
          NavigationDestination(
            icon: Icon(Icons.shopping_bag_outlined),
            selectedIcon: Icon(Icons.shopping_bag_rounded),
            label: 'Keranjang',
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite_border_rounded),
            selectedIcon: Icon(Icons.favorite_rounded),
            label: 'Favorit',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline_rounded),
            selectedIcon: Icon(Icons.person_rounded),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}
