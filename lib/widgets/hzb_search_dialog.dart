import 'package:flutter/material.dart';
import 'package:moshaf/utils/colors.dart';

class HizbSearchDialog extends StatelessWidget {
  final Map<int, List<int>> ahzab;
  final Function(int page) onPageSelected;
  final Function(int hizb) onHizbUpdated;
  final bool isNightMode;

  const HizbSearchDialog({
    super.key,
    required this.ahzab,
    required this.onPageSelected,
    required this.onHizbUpdated,
    required this.isNightMode,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).pop();
        },
        behavior: HitTestBehavior.opaque,
        child: Stack(
          children: [
            Positioned(
              bottom: 0,
              left: 0,
              child: GestureDetector(
                onTap: () {},
                child: Container(
                  width: MediaQuery.of(context).size.width > 600
                      ? MediaQuery.of(context).size.width * 0.5 // Tablets
                      : MediaQuery.of(context).size.width * 0.6, // Mobile
                  height: MediaQuery.of(context).size.height * 0.75,
                  decoration: BoxDecoration(
                    color:
                        isNightMode ? Colors.black : AppColors.cardBackground,
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(25.0),
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.grey,
                        blurRadius: 10,
                        offset: Offset(0, -5),
                      ),
                    ],
                  ),
                  child: Directionality(
                    textDirection: TextDirection.rtl,
                    child: Column(
                      children: [
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: ListView.builder(
                              itemCount: ahzab.keys.length,
                              itemBuilder: (context, index) {
                                int hizbNumber = ahzab.keys.elementAt(index);
                                return ListTile(
                                  title: Text(
                                    'الحِزب $hizbNumber',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.05 >
                                              18
                                          ? MediaQuery.of(context).size.width *
                                              0.05
                                          : 18,
                                      fontFamily: 'almushaf',
                                      color: isNightMode
                                          ? Colors.white
                                          : AppColors.primary,
                                    ),
                                  ),
                                  onTap: () {
                                    int pageIndex = ahzab[hizbNumber]![0] - 1;
                                    onPageSelected(pageIndex);
                                    onHizbUpdated(hizbNumber);
                                    Navigator.of(context).pop();
                                  },
                                );
                              },
                            ),
                          ),
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            style: TextButton.styleFrom(
                              backgroundColor: isNightMode
                                  ? AppColors.textSecondary
                                  : AppColors.primary,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.zero,
                              ),
                            ),
                            child: Text(
                              'إلغاء',
                              style: TextStyle(
                                fontSize: MediaQuery.of(context).size.width *
                                            0.05 >
                                        18
                                    ? MediaQuery.of(context).size.width * 0.05
                                    : 18, // Minimum size 18px
                                color: isNightMode
                                    ? Colors.black
                                    : AppColors.cardBackground,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
