import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import 'login_page.dart';

class RoleSelectionPage extends StatelessWidget {
  const RoleSelectionPage({super.key});

  void _openLogin(BuildContext context, String role) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => LoginPage(role: role),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_rounded),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),

              Container(
                width: 84,
                height: 84,
                decoration: const BoxDecoration(
                  color: AppColors.softPink,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.cake_rounded,
                  size: 45,
                  color: AppColors.chocolate,
                ),
              ),

              const SizedBox(height: 24),

              Text(
                'Welcome to\nButter & Crumb',
                textAlign: TextAlign.center,
                style: textTheme.headlineLarge,
              ),

              const SizedBox(height: 12),

              Text(
                'Pilih akunmu untuk melanjutkan '
                'perjalanan manis bersama kami.',
                textAlign: TextAlign.center,
                style: textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.7,
                ),
              ),

              const SizedBox(height: 36),

              _RoleCard(
                icon: Icons.admin_panel_settings_rounded,
                title: 'Login as Admin',
                subtitle: 'Kelola produk dan pesanan toko.',
                onTap: () => _openLogin(context, 'Admin'),
              ),

              const SizedBox(height: 16),

              _RoleCard(
                icon: Icons.shopping_bag_rounded,
                title: 'Continue as Client',
                subtitle: 'Belanja cake dan bakery favoritmu.',
                onTap: () => _openLogin(context, 'Client'),
              ),

              const Spacer(),

              Text(
                'A little sweetness goes a long way.',
                textAlign: TextAlign.center,
                style: textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _RoleCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Material(
      color: AppColors.cream,
      borderRadius: BorderRadius.circular(22),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: AppColors.divider),
          ),
          child: Row(
            children: [
              Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  color: AppColors.softCream,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  icon,
                  color: AppColors.chocolate,
                  size: 27,
                ),
              ),

              const SizedBox(width: 16),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: textTheme.titleMedium),
                    const SizedBox(height: 5),
                    Text(
                      subtitle,
                      style: textTheme.bodySmall,
                    ),
                  ],
                ),
              ),

              const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16,
                color: AppColors.mocha,
              ),
            ],
          ),
        ),
      ),
    );
  }
}