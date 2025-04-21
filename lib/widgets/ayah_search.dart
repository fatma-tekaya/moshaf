import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

class AyahSearch {
  static Future<List<Map<String, dynamic>>> loadQuranData(
      BuildContext context) async {
    final jsonString =
        await DefaultAssetBundle.of(context).loadString('assets/quran.json');
    final List<dynamic> data = json.decode(jsonString);
    List<Map<String, dynamic>> results = [];

    for (var surah in data) {
      final name = surah['name'];
      for (var verse in surah['verses']) {
        results.add({
          'surah': name,
          'verseText': verse['text'],
          'page': verse['page_number'],
          'eyahNumber': verse['id'],
        });
      }
    }

    return results;
  }

  static void showAyahSearchDialog(BuildContext context,
      List<Map<String, dynamic>> verses, Function(int page) onVerseSelected) {
    showSearch(
      context: context,
      delegate: AyahSearchDelegate(verses, onVerseSelected),
    );
  }
}

class AyahSearchDelegate extends SearchDelegate {
  final List<Map<String, dynamic>> verses;
  final Function(int) onVerseSelected;

  AyahSearchDelegate(this.verses, this.onVerseSelected);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [IconButton(onPressed: () => query = '', icon: Icon(Icons.clear))];
  }

  String normalizeArabic(String input) {
    return input
        // Remove diacritics
      .replaceAll(RegExp(r'[ًٌٍَُِّْۣۡۗۖۛۚۙۜ۝۞]'), '')
      // Normalize different alef forms
      .replaceAll('إ', 'ا')
      .replaceAll('أ', 'ا')
      .replaceAll('آ', 'ا')
      .replaceAll('ٱ', 'ا')
      .replaceAll('ىٰ', 'ا')
      // Normalize taa marbuta and haa
      .replaceAll('ة', 'ه')
      // Normalize yaa
      .replaceAll('ى', 'ي')
      .replaceAll('ئ', 'ي')
      // Normalize hamza
      .replaceAll('ؤ', 'و')
      .replaceAll('ء', '')
      // Normalize tatweel
      .replaceAll('ـ', '');
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () => close(context, null), icon: Icon(Icons.arrow_back));
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = verses.where((v) {
      final normalizedText = normalizeArabic(v['verseText'].toString());
      final normalizedQuery = normalizeArabic(query);
      return normalizedText.contains(normalizedQuery);
    }).toList();
    results.shuffle();
    return ListView.separated(
    padding: const EdgeInsets.all(16),
    itemCount: results.length,
    separatorBuilder: (_, __) => const SizedBox(height: 10),
    itemBuilder: (_, index) {
      final item = results[index];
      return GestureDetector(
        onTap: () {
          onVerseSelected(item['page'] - 1);
          close(context, null);
        },
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF7E6), // Beige doux
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.brown.withOpacity(0.15),
                blurRadius: 6,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item['verseText'],
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.justify,
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 2),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(Icons.arrow_forward_ios_rounded,
                      color: Colors.brown[400], size: 18),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'سورة ${item['surah']}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.brown[700],
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'صفحة ${item['page']} - آية ${item['eyahNumber']}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.brown[300],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}

  @override
  Widget buildSuggestions(BuildContext context) {
    return buildResults(context);
  }
}
