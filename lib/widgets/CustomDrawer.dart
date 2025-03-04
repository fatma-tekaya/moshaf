import 'package:flutter/material.dart';
import '../utils/colors.dart';
import '../screens/splash_screen.dart';
import 'launch_Facebook.dart';

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
    // final screenHeight = MediaQuery.of(context).size.height;
    // final isPortrait = screenHeight < screenWidth;
    // final isIpad = screenWidth > 700;
    return Drawer(
      width: screenWidth > 1200
          ? screenWidth * 0.5 // Large screens (Laptops, Large Tablets)
          : screenWidth > 800
              ? screenWidth * 0.5 // Medium Tablets
              : screenWidth * 0.7, // Default for Phones// Responsive drawer width
      child: Container(
        color: isNightMode ? AppColors.textPrimary : AppColors.sidBarBackground,
        child: Column(
          children: [
            // Drawer Header with background image
            DrawerHeader(
              decoration:  BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/Plan.png'),
                   fit: MediaQuery.of(context).size.width > 600 ? BoxFit.fill : BoxFit.cover, // Keeps aspect ratio while covering the header
                ),
              ),
              child: Container(
                height: MediaQuery.of(context).size.height *
                    0.40, // 25% of screen height
                alignment: Alignment.center, // Centers any child inside
                
              ),
            ),
            // Drawer Content
            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.05, // Responsive padding
                ),
                children: [
                  Text(
                    'اعدادات',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize:
                          screenWidth * 0.05 > 18 ? screenWidth * 0.05 : 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10), // Spacing
                  ListTile(
                    leading: Icon(
                      Icons.nightlight_round,
                      color: AppColors.textSecondary,
                      size: screenWidth * 0.06, // Responsive icon size
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
                  const SizedBox(height: 10), // Spacing
                  ListTile(
                    leading: Icon(
                      Icons.book_outlined,
                      color: AppColors.textSecondary,
                      size: screenWidth * 0.06, // Responsive icon size
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
                        : Colors.grey[200], // Highlight on tap
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.share,
                      color: AppColors.textSecondary,
                      size: screenWidth * 0.06, // Responsive icon size
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
                        : Colors.grey[200], // Highlight on tap
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
