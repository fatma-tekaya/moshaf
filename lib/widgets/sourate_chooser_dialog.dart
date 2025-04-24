import 'package:flutter/material.dart';
import '../utils/audio_helper.dart';

void showSouraChooserDialog(
    BuildContext context, List<String> sourates, VoidCallback onPlayStarted,{required bool isNightMode}) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text("اختر السورة"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: sourates.map((soura) {
          return ListTile(
            title: Text(soura),
            onTap: () async {
              Navigator.pop(context);
              await playAudio(soura,context);
              onPlayStarted(); // Appelle le callback ici !
            },
          );
        }).toList(),
      ),
    ),
  );
}

