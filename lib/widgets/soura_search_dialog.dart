import 'package:flutter/material.dart';

class SouraListDialog extends StatelessWidget {
  final Map<String, int> sourates;
  final Function(String sourateName, int pageIndex) onSouraSelected;

  const SouraListDialog({
    Key? key,
    required this.sourates,
    required this.onSouraSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'اختر السورة',
        textAlign: TextAlign.center,
      ),
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
                  sourateName,
                  style: const TextStyle(fontSize: 18.0),
                ),
                onTap: () {
                  int pageIndex = sourates[sourateName]! - 1;
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
          child: const Text('إلغاء'),
        ),
      ],
    );
  }
}
