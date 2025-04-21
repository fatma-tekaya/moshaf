import 'package:flutter/material.dart';
import '../utils/colors.dart';

class AjzaaSearchDialog extends StatelessWidget {
  final Map<int, List<Map<String, dynamic>>> ajzaa;
  final Map<int, List<int>> ahzab;
  final Function(int page) onPageSelected;
  final Function(int hizb) onHizbUpdated;
  final bool isNightMode;

  const AjzaaSearchDialog({
    super.key,
    required this.ajzaa,
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
        onTap: () => Navigator.of(context).pop(),
        behavior: HitTestBehavior.opaque,
        child: Stack(
          children: [
            Positioned(
              bottom: 0,
              left: 0,
              child: GestureDetector(
                onTap: () {},
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.8,
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
                    child: ListView(
                      children: ajzaa.entries.map((entry) {
                        int juzNumber = entry.key;
                        List<Map<String, dynamic>> hizbs = entry.value;

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: Text(
                                  'الجُزْء $juzNumber',
                                  style: TextStyle(
                                    fontFamily: 'almushaf',
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: isNightMode
                                        ? Colors.white
                                        : AppColors.primary,
                                  ),
                                ),
                              ),
                            ),
                            ...hizbs.map((hizbInfo) {
                              int hizbNum = hizbInfo['hizb'];
                              List<Map<String, dynamic>> parts =
                                  hizbInfo['subparts'];
                              return Card(
                                color: isNightMode
                                    ? Colors.grey.shade800
                                    : AppColors.cardBackground,
                                child: Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Text(
        'الحِزب $hizbNum',
        style: TextStyle(
          fontFamily: 'almushaf',
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: isNightMode ? Colors.white : AppColors.primary,
        ),
      ),
    ),
    GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 10),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, // 3 per row like your image
        childAspectRatio: 3.5,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
      ),
      itemCount: parts.length,
      itemBuilder: (context, index) {
        final part = parts[index];
        final label = part['label'];
        final page = part['page'];

        IconData icon;
        switch (label) {
          case '¼':
            icon = Icons.pin_invoke; break;
          case '½':
            icon = Icons.pin_invoke; break;
          case '¾':
            icon = Icons.pin_invoke; break;
          default:
            icon = Icons.circle; break;
        }

        return InkWell(
          onTap: () {
            onPageSelected(page - 1);
            onHizbUpdated(hizbNum);
            Navigator.of(context).pop();
          },
          child: Container(
            decoration: BoxDecoration(
              color: isNightMode ? Colors.grey.shade900 : AppColors.cardBackground,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'رُبْع $label',
                    style: TextStyle(
                      fontFamily: 'almushaf',
                      fontSize: 14,
                      color: isNightMode ? Colors.white : AppColors.primary,
                    ),
                  ),
                  SizedBox(width: 4),
                  Icon(icon, size: 16, color: isNightMode ? Colors.amber : AppColors.primary),
                ],
              ),
            ),
          ),
        );
      },
    ),
    SizedBox(height: 10),
  ],
)

                              );
                            }).toList(),
                          ],
                        );
                      }).toList(),
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
