import 'package:flutter/material.dart';
import '../utils/colors.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onThemeChanged;
  final void Function(String, int) onBookmarkPressed;
  final bool isNightMode;
  final BuildContext context;
  final bool isBookmarked;
  final GlobalKey<ScaffoldState> scaffoldKey;
  final int currentPage; // New parameter for the current page
  final String currentSourate; // New parameter for the current Surah name

  const CustomAppBar({
    required this.context,
    super.key,
    required this.onThemeChanged,
    required this.isNightMode,
    required this.onBookmarkPressed,
    required this.isBookmarked,
    required this.scaffoldKey,
    required this.currentPage, // Added
    required this.currentSourate, // Added
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isPortrait = screenHeight > screenWidth;

    return SafeArea(
      child: Container(
        // decoration: BoxDecoration(
        //   border: Border.all(
        //     color: const Color.fromARGB(255, 72, 0, 253), // Change this color for debugging or styling
        //     width: 3, // Thickness of the border
        //   ),
        //   borderRadius: BorderRadius.circular(12), // Optional: Rounded corners
        // ),
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: AppBar(
            backgroundColor:
                isNightMode ? AppColors.textPrimary : AppColors.textSecondary,
            leading: IconButton(
              icon: Icon(
                Icons.menu,
                size: (screenWidth * 0.05).clamp(30, 60),
              ),
              color: isNightMode ? AppColors.textSecondary : AppColors.primary,
              onPressed: () {
                scaffoldKey.currentState?.openDrawer();
              },
            ),
            actions: [
              IconButton(
                icon: Icon(
                  size: (screenWidth * 0.04).clamp(30, 60),
                  isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                ),
                color:
                    isNightMode ? AppColors.textSecondary : AppColors.primary,
              onPressed: () => onBookmarkPressed(currentSourate, currentPage),
             
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(
      kToolbarHeight * (MediaQuery.of(context).size.width > 600 ? 1 : 1));
}
