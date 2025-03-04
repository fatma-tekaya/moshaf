import 'package:flutter/material.dart';
import 'package:moshaf/utils/colors.dart';

void showPageSearchDialog(BuildContext context, int totalPages,
    Function(int) onPageSelected, bool isNightMode) {
  TextEditingController pageController = TextEditingController();

  final screenWidth = MediaQuery.of(context).size.width;
  final screenHeight = MediaQuery.of(context).size.height;

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: AppColors.textSecondary,
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(15), // Rounded corners for better UI
        ),
        title: Text(
          'الانتقال الى الصفحة',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: screenWidth * 0.045 > 18
                ? screenWidth * 0.045
                : 18, // Min font size 18px
            color: isNightMode ? AppColors.textPrimary : AppColors.primary,
          ),
        ),
        content: Directionality(
          textDirection: TextDirection.rtl,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: screenWidth * 0.8, // Limit width for large screens
              maxHeight:
                  screenHeight * 0.4, // Prevent overflow on small screens
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: pageController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'ادخل رقم الصفحة',
                    labelStyle: TextStyle(
                      fontSize: screenWidth * 0.045 > 16
                          ? screenWidth * 0.045
                          : 16, // Min 16px
                      color: AppColors.TextInput,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: isNightMode
                            ? AppColors.textPrimary
                            : AppColors.primary,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: isNightMode
                            ? AppColors.textPrimary
                            : AppColors.primary,
                      ),
                    ),
                  ),
                  style: TextStyle(
                    fontSize:
                        screenWidth * 0.045 > 16 ? screenWidth * 0.045 : 16,
                    color:
                        isNightMode ? AppColors.textPrimary : AppColors.primary,
                  ),
                ),
                const SizedBox(height: 16.0),
                Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: screenHeight * 0.06, // Responsive button height
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isNightMode
                              ? AppColors.textPrimary
                              : AppColors.cardBackground,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {
                          int? pageNumber = int.tryParse(pageController.text);
                          if (pageNumber != null &&
                              pageNumber > 0 &&
                              pageNumber <= totalPages) {
                            onPageSelected(pageNumber - 1);
                            Navigator.of(context).pop();
                          } else {
                            // Hide the keyboard before showing the SnackBar
                            FocusScope.of(context).unfocus();

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'رقم الصفحة غير صالح',
                                  style:
                                      TextStyle(color: AppColors.textSecondary),
                                ),
                                backgroundColor: isNightMode
                                    ? AppColors.textPrimary
                                    : AppColors.primary,
                                duration: Duration(
                                    seconds:
                                        2), // Ensures it disappears after 2 seconds
                                behavior: SnackBarBehavior
                                    .floating, // Makes it float above other elements
                                margin: EdgeInsets.only(
                                    bottom: 20,
                                    left: 20,
                                    right: 20), // Adjust position
                              ),
                            );
                          }
                        },
                        child: Text(
                          'إنتقال',
                          style: TextStyle(
                            fontSize: screenWidth * 0.045 > 16
                                ? screenWidth * 0.045
                                : 16,
                            color: isNightMode
                                ? AppColors.textSecondary
                                : AppColors.primary,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    SizedBox(
                      width: double.infinity,
                      height: screenHeight * 0.06,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          backgroundColor: isNightMode
                              ? AppColors.textSecondary
                              : AppColors.primary,
                          side: BorderSide(
                            color: isNightMode
                                ? AppColors.textPrimary
                                : AppColors.primary,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text(
                          'إلغاء',
                          style: TextStyle(
                            fontSize: screenWidth * 0.045 > 16
                                ? screenWidth * 0.045
                                : 16,
                            color: isNightMode
                                ? AppColors.textPrimary
                                : AppColors.cardBackground,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
