import 'package:flutter/material.dart';
import 'package:moshaf/utils/colors.dart';

class HizbSearchDialog extends StatelessWidget {
  final Map<int, List<int>> ahzab; // Map contenant les numéros des Hizbs et les pages correspondantes
  final Function(int page) onPageSelected; // Callback pour retourner la page sélectionnée
  final Function(int hizb) onHizbUpdated; // Callback pour mettre à jour le Hizb actuel
  final bool isNightMode;
  const HizbSearchDialog({
    Key? key,
    required this.ahzab,
    required this.onPageSelected,
    required this.onHizbUpdated,
    required this.isNightMode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: isNightMode ? Colors.black : AppColors.cardBackground,
      // title: const Text(
      //   'اختر الحزب',
      //   textAlign: TextAlign.center,
      // ),
      content: Directionality(
        textDirection: TextDirection.rtl,
        child: SizedBox(
          width: double.infinity,
          height: 400.0, // Ajustez cette hauteur selon vos besoins
          child: ListView.builder(
            itemCount: ahzab.keys.length,
            itemBuilder: (context, index) {
              int hizbNumber = ahzab.keys.elementAt(index);
              return ListTile(
                title: Text(
                  'الحزب $hizbNumber',
                  style: TextStyle(fontSize: 20.0, color: isNightMode
                        ? Colors.white
                        : AppColors.primary, // Change le texte
                  ),
                ),
                onTap: () {
                  int pageIndex = ahzab[hizbNumber]![0] - 1;
                  onPageSelected(pageIndex); // Appelle le callback avec la page
                  onHizbUpdated(hizbNumber); // Met à jour le Hizb actuel
                  Navigator.of(context).pop(); // Ferme la boîte de dialogue
                },
              );
            },
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('إلغاء',style: TextStyle(
              fontSize: 20.0,
              color: isNightMode
                  ? Colors.white
                  : AppColors.primary, // Change le texte
            ),),
        ),
      ],
    );
  }
}
