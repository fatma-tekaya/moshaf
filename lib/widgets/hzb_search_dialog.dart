import 'package:flutter/material.dart';

class HizbSearchDialog extends StatelessWidget {
  final Map<int, List<int>> ahzab; // Map contenant les numéros des Hizbs et les pages correspondantes
  final Function(int page) onPageSelected; // Callback pour retourner la page sélectionnée
  final Function(int hizb) onHizbUpdated; // Callback pour mettre à jour le Hizb actuel

  const HizbSearchDialog({
    super.key,
    required this.ahzab,
    required this.onPageSelected,
    required this.onHizbUpdated,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'اختر الحزب',
        textAlign: TextAlign.center,
      ),
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
                  style: const TextStyle(fontSize: 18.0),
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
          child: const Text('إلغاء'),
        ),
      ],
    );
  }
}
