
import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../services/auth_service.dart';

class ProfilePage extends StatelessWidget {
  final String clientEmail;
  final VoidCallback onLogout;

  const ProfilePage({
    super.key,
    required this.clientEmail,
    required this.onLogout,
  });

  String get clientName =>
      AuthService.getClientName(clientEmail) ?? 'Sweet Customer';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.softCream,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const SizedBox(height: 12),

            // Header
            const Text(
              'My Profile',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppColors.chocolate,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Your little corner of sweetness 🤎',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),

            const SizedBox(height: 28),

            // Profile card
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    AppColors.softPink,
                    AppColors.cream,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppColors.divider),
              ),
              child: Column(
                children: [
                  Container(
                    width: 94,
                    height: 94,
                    decoration: BoxDecoration(
                      color: AppColors.cream,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.caramel,
                        width: 2,
                      ),
                    ),
                    child: const Icon(
                      Icons.person_rounded,
                      size: 52,
                      color: AppColors.chocolate,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    clientName,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.chocolate,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    clientEmail,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.cream,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.favorite_rounded,
                          color: AppColors.caramel,
                          size: 17,
                        ),
                        SizedBox(width: 6),
                        Text(
                          'Butter & Crumb Member',
                          style: TextStyle(
                            color: AppColors.chocolate,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            const Text(
              'Account',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.chocolate,
              ),
            ),
            const SizedBox(height: 14),

            _profileMenu(
              icon: Icons.person_outline_rounded,
              title: 'Personal Information',
              subtitle: 'View your account details',
              onTap: () => _showInfoDialog(
                context,
                'Personal Information',
                'Name: $clientName\n\nEmail: $clientEmail',
              ),
            ),

            _profileMenu(
              icon: Icons.notifications_none_rounded,
              title: 'Notifications',
              subtitle: 'Stay updated with your orders',
              onTap: () => _showInfoDialog(
                context,
                'Notifications',
                'Order updates and sweet news will be available here.',
              ),
            ),

            _profileMenu(
              icon: Icons.help_outline_rounded,
              title: 'Help & Support',
              subtitle: 'Need a little help?',
              onTap: () => _showInfoDialog(
                context,
                'Help & Support',
                'Thank you for choosing Butter & Crumb! '
                    'For now, you can contact our team through the '
                    'bakery’s available contact channels.',
              ),
            ),

            const SizedBox(height: 28),

            // Logout button
            SizedBox(
              height: 54,
              child: OutlinedButton.icon(
                onPressed: () => _confirmLogout(context),
                icon: const Icon(Icons.logout_rounded),
                label: const Text(
                  'Log Out',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.chocolate,
                  side: const BorderSide(
                    color: AppColors.caramel,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            const Center(
              child: Text(
                'Made with ♡ and a little sugar',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _profileMenu({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.cream,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.divider),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        leading: Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            color: AppColors.softPink,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(
            icon,
            color: AppColors.chocolate,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            color: AppColors.chocolate,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 12,
          ),
        ),
        trailing: const Icon(
          Icons.chevron_right_rounded,
          color: AppColors.mocha,
        ),
        onTap: onTap,
      ),
    );
  }

  void _showInfoDialog(
    BuildContext context,
    String title,
    String message,
  ) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.cream,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22),
        ),
        title: Text(
          title,
          style: const TextStyle(
            color: AppColors.chocolate,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          message,
          style: const TextStyle(
            color: AppColors.textSecondary,
            height: 1.6,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text(
              'Okay',
              style: TextStyle(
                color: AppColors.chocolate,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _confirmLogout(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.cream,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22),
        ),
        title: const Text(
          'Leaving so soon? 🥺',
          style: TextStyle(
            color: AppColors.chocolate,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: const Text(
          'Are you sure you want to log out of your account?',
          style: TextStyle(
            color: AppColors.textSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text(
              'Stay',
              style: TextStyle(color: AppColors.mocha),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              onLogout();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.chocolate,
              foregroundColor: Colors.white,
            ),
            child: const Text('Log Out'),
          ),
        ],
      ),
    );
  }
}
