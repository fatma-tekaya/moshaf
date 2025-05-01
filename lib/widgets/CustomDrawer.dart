import 'package:flutter/material.dart';
import '../utils/colors.dart';
import '../screens/splash_screen.dart';
import 'launch_Facebook.dart';
import '../screens/historique_screen.dart';
import '../screens/aamalna_screen.dart';
import 'package:share_plus/share_plus.dart';

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
    final screenWidth = MediaQuery.of(context).size.width;
    void shareApp() {
      const playStoreLink =
          'https://play.google.com/store/apps/details?id=com.almoshaf.moshaf';

      Share.share(
        '📖 حمّل تطبيق المصحف الشريف وابدأ القراءة:\n\n$playStoreLink',
      );
    }

    return Drawer(
      width: screenWidth > 1200
          ? screenWidth * 0.5 
          : screenWidth > 800
              ? screenWidth * 0.5 
              : screenWidth *
                  0.7, 
      child: Container(
        color: isNightMode ? AppColors.textPrimary : AppColors.sidBarBackground,
        child: Column(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/Plan.png'),
                  fit: MediaQuery.of(context).size.width > 600
                      ? BoxFit.fill
                      : BoxFit
                          .cover,
                ),
              ),
              child: Container(
                height: MediaQuery.of(context).size.height *
                    0.40,
                alignment: Alignment.center, 
              ),
            ),
            // Drawer Content
            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.05, 
                ),
                children: [
                  Text(
                    'إِعدادات',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize:
                          screenWidth * 0.05 > 18 ? screenWidth * 0.05 : 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10), 
                  ListTile(
                    leading: Icon(
                      Icons.nightlight_round,
                      color: AppColors.textSecondary,
                      size: screenWidth * 0.06, 
                    ),
                    title: Text(
                      'تبديل الوضع الليلي',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize:
                            screenWidth * 0.05 > 18 ? screenWidth * 0.05 : 18,
                      ),
                    ),
                    onTap: onToggleNightMode,
                    tileColor: isNightMode
                        ? Colors.grey[800]
                        : Colors.grey[200], // Highlight on tap
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.history, 
                      color: AppColors.textSecondary,
                      size: screenWidth * 0.06, 
                    ),
                    title: Text(
                      'مرجعيات',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize:
                            screenWidth * 0.05 > 18 ? screenWidth * 0.05 : 18,
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              HistoriqueScreen(isNightMode: isNightMode),
                        ),
                      );
                    },
                    tileColor: isNightMode
                        ? Colors.grey[800]
                        : Colors.grey[200], 
                  ),
                  const Divider(
                    thickness: 1.5,
                    color: AppColors.textSecondary,
                  ), // Divider
                  Text(
                    'حول التطبيقة',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize:
                          screenWidth * 0.05 > 18 ? screenWidth * 0.05 : 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10), 
                  ListTile(
                    leading: Icon(
                      Icons.rocket_launch,
                      color: AppColors.textSecondary,
                      size: screenWidth * 0.06, 
                    ),
                    title: Text(
                      ' أعمالنا المستقبلية',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize:
                            screenWidth * 0.05 > 18 ? screenWidth * 0.05 : 18,
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const AamalnaScreen(), 
                        ),
                      );
                    },
                    tileColor: isNightMode
                        ? Colors.grey[800]
                        : Colors.grey[200], 
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.book_outlined,
                      color: AppColors.textSecondary,
                      size: screenWidth * 0.06, 
                    ),
                    title: Text(
                      'المؤسسات المشاركة',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize:
                            screenWidth * 0.05 > 18 ? screenWidth * 0.05 : 18,
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const SplashScreen(redirectToHome: false),
                        ),
                      );
                    },
                    tileColor: isNightMode
                        ? Colors.grey[800]
                        : Colors.grey[200], 
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.facebook_outlined,
                      color: AppColors.textSecondary,
                      size: screenWidth * 0.06, 
                    ),
                    title: Text(
                      'تواصل معنا',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize:
                            screenWidth * 0.05 > 18 ? screenWidth * 0.05 : 18,
                      ),
                    ),
                    onTap: () =>
                        LaunchFacebook.showFacebookChoiceDialog(context),
                    tileColor: isNightMode
                        ? Colors.grey[800]
                        : Colors.grey[200], 
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.share,
                      color: AppColors.textSecondary,
                      size: screenWidth * 0.06, 
                    ),
                    title: Text(
                      'شارك التطبيق',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize:
                            screenWidth * 0.05 > 18 ? screenWidth * 0.05 : 18,
                      ),
                    ),
                    onTap: () => shareApp(),
                    tileColor: isNightMode
                        ? Colors.grey[800]
                        : Colors.grey[200], 
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
