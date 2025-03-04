import 'package:flutter/material.dart';
import 'package:moshaf/utils/colors.dart';

class SouraListDialog extends StatelessWidget {
  final Map<String, List<int>> sourates;
  final Function(String sourateName, int pageIndex) onSouraSelected;
  final bool isNightMode;

  const SouraListDialog({
    super.key,
    required this.sourates,
    required this.onSouraSelected,
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
              right: 0,
              child: GestureDetector(
                onTap: () {}, // Bloque le clic sur le widget lui-même
                child: Container(
                  width: MediaQuery.of(context).size.width > 600
                      ? MediaQuery.of(context).size.width *
                          0.5 // Tablet: 60% of width
                      : MediaQuery.of(context).size.width * 0.6,
                  height: MediaQuery.of(context).size.height * 0.9,
                  decoration: BoxDecoration(
                    color:
                        isNightMode ? Colors.black : AppColors.cardBackground,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(25.0),
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
                              itemCount: sourates.keys.length,
                              itemBuilder: (context, index) {
                                String sourateName =
                                    sourates.keys.elementAt(index);
                                return ListTile(
                                  title: Text(
                                    "${sourates.keys.toList().indexOf(sourateName) + 1}. سورة $sourateName",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: MediaQuery.of(context) .size.width * 0.05 > 18
                                          ? MediaQuery.of(context).size.width * 0.05  : 18,
                                      fontFamily: 'almushaf',
                                      color: isNightMode
                                          ? Colors.white
                                          : AppColors.primary,
                                    ),

                                    maxLines: 1, // Ensures it doesn't wrap
                                    overflow: TextOverflow
                                        .ellipsis, // Adds "..." if too long
                                  ),
                                  onTap: () {
                                    int pageIndex =
                                        sourates[sourateName]![0] - 1;
                                    onSouraSelected(sourateName, pageIndex);
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
                                fontSize: MediaQuery.of(context).size.width *  0.05 > 18
                                    ? MediaQuery.of(context).size.width * 0.05
                                    : 18, // Minimum size 18px,
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
