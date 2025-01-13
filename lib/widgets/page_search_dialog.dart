import 'package:flutter/material.dart';
import 'package:moshaf/utils/colors.dart';

void showPageSearchDialog(BuildContext context, int totalPages,
    Function(int) onPageSelected, bool isNightMode) {
  TextEditingController pageController = TextEditingController();

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: AppColors.textSecondary,
        title: Text(
          'الانتقال الى الصفحة',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize:  MediaQuery.of(context).size.width * 0.05,
            color: isNightMode ? AppColors.textPrimary : AppColors.primary,
          ),
        ),
        content: Directionality(
          textDirection: TextDirection.rtl,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: pageController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'ادخل رقم الصفحة',
                  labelStyle: TextStyle(
                    fontSize:  MediaQuery.of(context).size.width * 0.05,
                    color: AppColors.TextInput,
                  ),
                  border: const OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      //width: 2.0,
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
                  fontSize:  MediaQuery.of(context).size.width * 0.05,
                  color:
                      isNightMode ? AppColors.textPrimary : AppColors.primary,
                ),
              ),
              const SizedBox(height: 16.0),
              Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isNightMode
                            ? AppColors.textPrimary
                            : AppColors.cardBackground,
                      ),
                      onPressed: () {
                        int? pageNumber = int.tryParse(pageController.text);
                        if (pageNumber != null &&
                            pageNumber > 0 &&
                            pageNumber <= totalPages) {
                          onPageSelected(pageNumber - 1);
                          Navigator.of(context).pop();
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'رقم الصفحة غير صالح',
                                style: TextStyle(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              backgroundColor: isNightMode
                                  ? AppColors.textPrimary
                                  : AppColors.primary,
                            ),
                          );
                        }
                      },
                      child: Text(
                        'إنتقال',
                        style: TextStyle(
                          fontSize:  MediaQuery.of(context).size.width * 0.05,
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
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text(
                        'إلغاء',
                        style: TextStyle(
                          fontSize:  MediaQuery.of(context).size.width * 0.05,
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
      );
    },
  );
}
