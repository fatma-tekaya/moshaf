import 'package:flutter/material.dart';
import 'package:moshaf/utils/colors.dart';

class HizbSearchDialog extends StatelessWidget {
  final Map<String, Map<int, Map<String, int>>> data;
  final Function(int page) onPageSelected;
  final Function(int hizb) onHizbUpdated;
  final bool isNightMode;

  const HizbSearchDialog({
    super.key,
    required this.data,
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
                  width: MediaQuery.of(context).size.width > 600
                      ? MediaQuery.of(context).size.width * 0.85
                      : MediaQuery.of(context).size.width * 0.9,
                  height: MediaQuery.of(context).size.height * 0.8,
                  decoration: BoxDecoration(
                    color:
                        isNightMode ? Colors.black : AppColors.cardBackground,
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(25.0),
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
                        // Scrollable content
                        Expanded(
                          child: ListView(
                            padding: const EdgeInsets.all(4.0),
                            children: [
                              ...data.entries.map((partEntry) {
                                String partName = partEntry.key;
                                Map<int, Map<String, int>> hizbSections =
                                    partEntry.value;

                                return Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 1.0),
                                      child: Text(
                                        partName,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                          color: isNightMode
                                              ? Colors.white
                                              : AppColors.primary,
                                        ),
                                      ),
                                    ),
                                    ...hizbSections.entries.map((hizbEntry) {
                                      int hizbNumber = hizbEntry.key;
                                      Map<String, int> sections =
                                          hizbEntry.value;

                                      return Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 1.0),
                                            child: Text(
                                              'الحزب $hizbNumber',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: 20,
                                                color: isNightMode
                                                    ? Colors.white
                                                    : AppColors.primary,
                                              ),
                                            ),
                                          ),
                                          Table(
                                            columnWidths: const {
                                              0: FlexColumnWidth(),
                                              1: FlexColumnWidth(),
                                              2: FlexColumnWidth(),
                                              3: FlexColumnWidth(),
                                            },
                                            children: [
                                              TableRow(
                                                children: sections.entries
                                                    .map((section) {
                                                  return Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            1.0),
                                                    child: SizedBox(
                                                      width: 80,
                                                      height: 85,
                                                      child: Card(
                                                        color: isNightMode
                                                            ? Colors
                                                                .grey.shade800
                                                            : Colors.orange
                                                                .shade100,
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(12),
                                                        ),
                                                        elevation: 2,
                                                        child: InkWell(
                                                          onTap: () {
                                                            onPageSelected(
                                                                section.value -
                                                                    1);
                                                            onHizbUpdated(
                                                                hizbNumber);
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Image.asset(
                                                                  getImagePath(
                                                                      section
                                                                          .key),
                                                                  width: 20,
                                                                  height: 20,
                                                                ),
                                                                const SizedBox(
                                                                    height: 4),
                                                                Text(
                                                                  sectionLabel(
                                                                      section
                                                                          .key),
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        12,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    color: isNightMode
                                                                        ? Colors
                                                                            .white
                                                                        : Colors
                                                                            .black,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                }).toList(),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 10),
                                        ],
                                      );
                                    }).toList(),
                                    Divider(
                                      color: Colors.grey.shade400,
                                      thickness: 1,
                                    ),
                                  ],
                                );
                              }).toList(),
                            ],
                          ),
                        ),

                        // ✅ Fixed Cancel Button
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
                                    : 18,
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

  String getImagePath(String sectionName) {
    switch (sectionName) {
      case '3/4':
        return 'assets/0,75.png';
      case '1/2':
        return 'assets/0,5.png';
      case '1/4':
        return 'assets/0,25.png';
      default:
        return 'assets/1.png';
    }
  }

  String sectionLabel(String key) {
    switch (key) {
      case '1/4':
        return 'رُبْع\nالحزب';
      case '1/2':
        return 'نِصف\nالحزب';
      case '3/4':
        return 'ثلاثة أرباع\nالحزب';
      case 'ح':
        return 'بداية \nالحزب';
      default:
        return key;
    }
  }
}
