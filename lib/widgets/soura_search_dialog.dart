import 'package:flutter/material.dart';
import 'package:moshaf/utils/colors.dart';

class SouraListDialog extends StatelessWidget {
  final Map<String, List<int>> sourates;
  final Function(String sourateName, int pageIndex) onSouraSelected;
  final bool isNightMode;
  const SouraListDialog({
    Key? key,
    required this.sourates,
    required this.onSouraSelected,
    required this.isNightMode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: isNightMode ? Colors.black : AppColors.cardBackground,
      // title: const Text(
      //   'اختر السورة',
      //   textAlign: TextAlign.center,
      // ),
      content: Directionality(
        textDirection: TextDirection.rtl,
        child: SizedBox(
          width: double.infinity,
          height: 400.0, // Ajustez si nécessaire
          child: ListView.builder(
            itemCount: sourates.keys.length,
            itemBuilder: (context, index) {
              String sourateName = sourates.keys.elementAt(index);
              return ListTile(
                title: Text(
                  "سورة $sourateName",
                  style: TextStyle(
                    fontSize: 20.0,
                    color: isNightMode
                        ? Colors.white
                        : AppColors.primary, // Change le texte
                  ),
                ),
                onTap: () {
                  int pageIndex = sourates[sourateName]![0] -
                      1; // Corrected to access the start page from the list
                  onSouraSelected(sourateName, pageIndex);
                  Navigator.of(context).pop(); // Fermer la boîte de dialogue
                },
              );
            },
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            'إلغاء',
            style: TextStyle(
              fontSize: 20.0,
              color: isNightMode
                  ? Colors.white
                  : AppColors.primary, // Change le texte
            ),
          ),
        ),
      ],
    );
  }
}
