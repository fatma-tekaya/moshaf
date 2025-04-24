import 'package:flutter/material.dart';
import 'package:moshaf/utils/colors.dart';
import '../utils/audio_helper.dart';
import '../utils/constants.dart';
import 'sourate_chooser_dialog.dart';

class AudioPlayButton extends StatefulWidget {
  final int currentPage;
  final bool isNightMode;

  const AudioPlayButton({
    super.key,
    required this.currentPage,
    required this.isNightMode,
  });

  @override
  State<AudioPlayButton> createState() => _AudioPlayButtonState();
}

class _AudioPlayButtonState extends State<AudioPlayButton> {
  bool isPlaying = false;

  bool isFirstPageOfSoura(int page, String soura) {
    final range = sourates[soura];
    if (range == null) return false;
    return page == range[0]; // only show if current page is the start
  }

  List<String> getSouratesOnPage(int page) {
    return sourates.entries
        .where((entry) => page >= entry.value[0] && page <= entry.value[1])
        .map((entry) => entry.key)
        .toList();
  }

  void handleAudioPlayPause(List<String> souratesOnPage) async {
    if (isPlaying) {
      await pauseAudio();
      setState(() {
        isPlaying = false;
      });
    } else {
      if (souratesOnPage.length == 1) {
        await playAudio(souratesOnPage.first, context);
        setState(() {
          isPlaying = true;
        });
      } else {
        showSouraChooserDialog(context, souratesOnPage, () {
          setState(() {
            isPlaying = true;
          });
        }, isNightMode: widget.isNightMode);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final souratesOnPage = getSouratesOnPage(widget.currentPage + 1);

    // Show only if one soura on page AND it's the first page of it
    // if (souratesOnPage.length == 1 &&
    //     !isFirstPageOfSoura(widget.currentPage + 1, souratesOnPage.first)) {
    //   return const SizedBox.shrink(); // hide button
    // }

    return Padding(
      padding: const EdgeInsets.all(1.0),
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor:widget.isNightMode? const Color.fromARGB(255, 40, 39, 39): Colors.white,
          foregroundColor: widget.isNightMode? Colors.white : AppColors.primary,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
        label: Text(isPlaying ? "إيقاف مؤقت" : "تشغيل السورة"),
        onPressed: () => handleAudioPlayPause(souratesOnPage),
      ),
    );
  }
}
