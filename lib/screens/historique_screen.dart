import 'package:flutter/material.dart';
import 'package:moshaf/utils/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HistoriqueScreen extends StatefulWidget {
  final bool isNightMode;
  const HistoriqueScreen({super.key, required this.isNightMode});

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
    final backgroundColor = widget.isNightMode ? Colors.black : Colors.white;
    final textColor = widget.isNightMode ? Colors.white : Colors.black;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(
          'المرجعيات',
          style: TextStyle(
            fontSize: screenWidth * 0.06 > 24 ? 24 : screenWidth * 0.06,
            color: Colors.white,
          ),
        ),
        backgroundColor:
            widget.isNightMode ? Colors.grey[900] : AppColors.primary,
      ),
      body: _savedPages.isEmpty
          ? Center(
              child: Text(
                'لا توجد صفحات محفوظة',
                style: TextStyle(
                  fontSize: 22,
                  fontFamily: 'almushaf',
                  color: textColor,
                ),
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
                  tileColor: widget.isNightMode
                      ? Colors.black
                      : Colors.transparent,
                  title: Text(
                    surah,
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  subtitle: Text(
                    'صفحة ${int.parse(pageNumber) + 1}   -   $date',
                    textAlign: TextAlign.right,
                    style: TextStyle(fontSize: 16, color: textColor),
                  ),
                  leading: Icon(Icons.bookmark,
                      color: widget.isNightMode ? Colors.white : AppColors.primary),
                  trailing: IconButton(
                    icon: Icon(Icons.close,
                        color:
                            widget.isNightMode ? Colors.white : Colors.grey),
                    onPressed: () => _removeBookmark(_savedPages[index]),
                  ),
                );
              },
            ),
    );
  }
}
