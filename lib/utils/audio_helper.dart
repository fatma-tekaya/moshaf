import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:moshaf/utils/colors.dart';
final AudioPlayer player = AudioPlayer(); // Global player
Future<void> playAudio(String soura, BuildContext context) async {
  try {
    await player.play(AssetSource('audios/$soura.mp3'));
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Row(
          children:  [
            Icon(Icons.error_outline, color: Colors.white),
            SizedBox(width: 10),
            Expanded(child: Text("عذرًا، الملف الصوتي لهذه السورة غير موجود")),
          ],
        ),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(12),
        duration: const Duration(seconds: 4),
      ),
    );
  }
}

Future<void> pauseAudio() async {
  await player.pause();
}

Future<void> resumeAudio() async {
  await player.resume();
}
