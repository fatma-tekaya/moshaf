import 'package:flutter/material.dart';
import '../utils/colors.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onThemeChanged;
  final VoidCallback onBookmarkPressed;
  final bool isNightMode;
  final bool isBookmarked;
  final GlobalKey<ScaffoldState> scaffoldKey;

  const CustomAppBar({
    super.key,
    required this.onThemeChanged,
    required this.isNightMode,
    required this.onBookmarkPressed,
    required this.isBookmarked,
    required this.scaffoldKey,
  });

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: AppBar(
        backgroundColor:
            isNightMode ? AppColors.textPrimary : AppColors.textSecondary,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          color: isNightMode ? AppColors.textSecondary : AppColors.primary,
          onPressed: () {
            scaffoldKey.currentState?.openDrawer();
          },
        ),
        actions: [
          IconButton(
            icon: Icon(
              isBookmarked ? Icons.bookmark : Icons.bookmark_border,
              color: isNightMode ? AppColors.textSecondary : AppColors.primary,
            ),
            onPressed: onBookmarkPressed,
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
