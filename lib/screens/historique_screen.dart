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

  Future<List<String>> _loadSavedPages() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('savedPages') ?? [];
  }

  void _removeBookmark(String entry) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _savedPages.remove(entry);
    });
    await prefs.setStringList('savedPages', _savedPages);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'المرجعيات',
          style: TextStyle(
            fontSize:
                screenWidth * 0.06 > 24 ? 24 : screenWidth * 0.06, // Dynamique
          ),
        ),
        backgroundColor: AppColors.primary,
      ),
      body: FutureBuilder<List<String>>(
        future: _loadSavedPages(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'لا توجد صفحات محفوظة',
                style: TextStyle(fontSize: 22, fontFamily: 'almushaf'),
              ),
            );
          }

          List<String> savedPages = snapshot.data!;
          return ListView.builder(
            itemCount: savedPages.length,
            itemBuilder: (context, index) {
              final parts = savedPages[index].split('|');
              final date = parts[0];
              final surah = parts[1];
              final pageNumber = parts[2];

              return ListTile(
                title: Text(surah,
                    textAlign: TextAlign.right,
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                subtitle: Text(
                  'صفحة ${int.parse(pageNumber) + 1}   -   $date',
                  textAlign: TextAlign.right,
                  style: TextStyle(fontSize: 16),
                ),
                leading: const Icon(Icons.bookmark, color: Colors.brown),
                trailing: IconButton(
                  icon: const Icon(Icons.close, color: Colors.grey),
                  onPressed: () => _removeBookmark(savedPages[index]),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
