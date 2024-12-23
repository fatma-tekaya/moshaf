import 'package:flutter/material.dart';
import '../utils/colors.dart';

class CustomDrawer extends StatelessWidget {
  final bool isNightMode;
  final VoidCallback onToggleNightMode;

  const CustomDrawer({
    super.key,
    required this.isNightMode,
    required this.onToggleNightMode,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: isNightMode ? AppColors.textSecondary : AppColors.cardBackground,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            // Header du Drawer
            DrawerHeader(
              decoration: BoxDecoration(
                color: isNightMode ? AppColors.textPrimary : AppColors.primary,
              ),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Logo
                    Flexible(
                      child: Image.asset(
                        'assets/logo1.png',
                        fit: BoxFit.contain, // S'adapte à l'espace disponible
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'المصحف الشريف',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Changement du mode nuit
            ListTile(
              leading: Icon(
                Icons.nightlight_round,
                color: isNightMode ? AppColors.textPrimary : AppColors.textSecondary,
              ),
              title: Text(
                'تبديل الوضع الليلي',
                style: TextStyle(
                  color: isNightMode ? AppColors.textPrimary: AppColors.textSecondary,
                ),
              ),
              onTap: onToggleNightMode,
            ),
            const Divider(color: AppColors.textSecondary),
            // À propos
            ListTile(
              leading: Icon(
                Icons.info,
                color: isNightMode ? AppColors.textPrimary : AppColors.textSecondary,
              ),
              title: Text(
                'حول التطبيق',
                style: TextStyle(
                  color: isNightMode ? AppColors.textPrimary : AppColors.textSecondary,
                ),
              ),
              onTap: () {
                // Action pour "حول التطبيق"
              },
            ),
            // Contact
            ListTile(
              leading: Icon(
                Icons.mail,
                color: isNightMode ? AppColors.textPrimary : AppColors.textSecondary,
              ),
              title: Text(
                'تواصل معنا',
                style: TextStyle(
                  color: isNightMode ? AppColors.textPrimary : AppColors.textSecondary,
                ),
              ),
              onTap: () {
                // Action pour "تواصل معنا"
              },
            ),
          ],
        ),
      ),
    );
  }
}
