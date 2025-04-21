import 'package:flutter/material.dart';
import 'package:moshaf/utils/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HistoriqueScreen extends StatefulWidget {
  const HistoriqueScreen({super.key});

  @override
  _HistoriqueScreenState createState() => _HistoriqueScreenState();
}

class _HistoriqueScreenState extends State<HistoriqueScreen> {
  List<String> _savedPages = [];

  @override
  void initState() {
    super.initState();
    _loadSavedPages();
  }

  Future<void> _loadSavedPages() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> saved = prefs.getStringList('savedPages') ?? [];
    setState(() {
      _savedPages = saved;
    });
  }

  void _removeBookmark(String entry) async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      _savedPages.remove(entry);
    });

    await prefs.setStringList('savedPages', _savedPages);

    // Supprimer aussi la page courante si c'était la dernière
    final lastSaved = prefs.getInt('lastSavedPage');
    if (_savedPages.isEmpty || entry.contains('|${lastSaved.toString()}')) {
      await prefs.remove('lastSavedPage');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'المرجعيات',
          style: TextStyle(
            fontSize: screenWidth * 0.06 > 24 ? 24 : screenWidth * 0.06,
          ),
        ),
        backgroundColor: AppColors.primary,
      ),
      body: _savedPages.isEmpty
          ? const Center(
              child: Text(
                'لا توجد صفحات محفوظة',
                style: TextStyle(fontSize: 22, fontFamily: 'almushaf'),
              ),
            )
          : ListView.builder(
              itemCount: _savedPages.length,
              itemBuilder: (context, index) {
                final parts = _savedPages[index].split('|');
                final date = parts[0];
                final surah = parts[1];
                final pageNumber = parts[2];

                return ListTile(
                  title: Text(
                    surah,
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    'صفحة ${int.parse(pageNumber) + 1}   -   $date',
                    textAlign: TextAlign.right,
                    style: const TextStyle(fontSize: 16),
                  ),
                  leading: const Icon(Icons.bookmark, color: Colors.brown),
                  trailing: IconButton(
                    icon: const Icon(Icons.close, color: Colors.grey),
                    onPressed: () => _removeBookmark(_savedPages[index]),
                  ),
                );
              },
            ),
    );
  }
}
