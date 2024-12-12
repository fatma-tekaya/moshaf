import 'package:flutter/material.dart';

void showPageSearchDialog(
    BuildContext context, int totalPages, Function(int) onPageSelected) {
  TextEditingController _pageController = TextEditingController();

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text(
          'الانتقال الى الصفحة',
          textAlign: TextAlign.center,
        ),
        content: Directionality(
          textDirection: TextDirection.rtl,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _pageController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'ادخل رقم الصفحة',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16.0),
              Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        int? pageNumber = int.tryParse(_pageController.text);
                        if (pageNumber != null &&
                            pageNumber > 0 &&
                            pageNumber <= totalPages) {
                          onPageSelected(totalPages - pageNumber);
                          Navigator.of(context).pop();
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('رقم الصفحة غير موجود'),
                            ),
                          );
                        }
                      },
                      child: const Text('بحث'),
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('إلغاء'),
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
