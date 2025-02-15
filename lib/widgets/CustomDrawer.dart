import 'package:flutter/material.dart';
import '../utils/colors.dart';
import '../screens/splash_screen.dart';
import '../utils/launch_Facebook.dart';

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
        color: isNightMode ? AppColors.textPrimary : AppColors.sidBarBackground,
        child: Column(
          children: [
            // Drawer Header avec image en arrière-plan
            DrawerHeader(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/Plan.png'), // Chemin de l'image
                  fit: BoxFit.cover, // L'image occupe tout l'espace
                ),
              ),
              child: Container(), // Vide pour afficher uniquement l'image
            ),
            // Contenu après l'image
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0), // Espacement des côtés
                children: [
                  Text(
                    'اعدادات',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: MediaQuery.of(context).size.width * 0.06,
                    ),
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.nightlight_round,
                      color: AppColors.textSecondary,
                      size: MediaQuery.of(context).size.width * 0.06,
                    ),
                    title: Text(
                      'تبديل الوضع الليلي',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: MediaQuery.of(context).size.width * 0.05,
                      ),
                    ),
                    onTap: onToggleNightMode,
                  ),
                  const Divider(
                    thickness: 1.5,
                    color: AppColors.textSecondary,
                  ), // Ligne de séparation épaisse
                  Text(
                    'حول التطبيقة',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: MediaQuery.of(context).size.width * 0.06,
                    ),
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.book_outlined,
                      color: AppColors.textSecondary,
                      size: MediaQuery.of(context).size.width * 0.06,
                    ),
                    title: Text(
                      'المؤسسات المشاركة',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: MediaQuery.of(context).size.width * 0.05,
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const SplashScreen(redirectToHome: false)),
                      );
                    },
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.share,
                      color: AppColors.textSecondary,
                      size: MediaQuery.of(context).size.width * 0.06,
                    ),
                    title: Text(
                      'تواصل معنا',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: MediaQuery.of(context).size.width * 0.05,
                      ),
                    ),
                    onTap: () => LaunchFacebook.showFacebookChoiceDialog(
                        context),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
