import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import '../screens/ocr.dart';
import '../widgets/page_search_dialog.dart';
import '../widgets/CustomAppBar.dart';
import '../widgets/CustomDrawer.dart';
import '../widgets/soura_search_dialog.dart';
import '../widgets/hzb_search_dialog.dart';
import '../utils/constants.dart';
import '../utils/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PdfHomePage extends StatefulWidget {
  final VoidCallback onThemeChanged;
  const PdfHomePage({super.key, required this.onThemeChanged});

  @override
  _PdfHomePageState createState() => _PdfHomePageState();
}

class _PdfHomePageState extends State<PdfHomePage> {
  int? _savedPage; // Page sauvegardée
  bool _isBookmarked = false; // État du marque-page
  String _pdfPath = "";
  int _totalPages = 0;
  int _currentPage = 0;
  String _currentSourate = "الفاتحة";
  int _currentHizb = 1;
  bool _isNightMode = false;
  PDFViewController? _pdfViewController;
  final Map<String, List<int>> _sourates = sourates;
  final Map<int, List<int>> _ahzab = ahzab;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _loadPdf();
  }

  Future<void> _loadPdf() async {
    final prefs = await SharedPreferences.getInstance();
    _savedPage =
        prefs.getInt('savedPage'); // Récupération de la page sauvegardée
    print("Page sauvegardée récupérée $_savedPage");
    final pdfFile = await _copyPdfFromAssets();
    setState(() {
      _pdfPath = pdfFile.path;
    });
  }

  Future<File> _copyPdfFromAssets() async {
    final dir = await getTemporaryDirectory();
    final file = File("${dir.path}/Qaloun13v2.pdf");

    if (!await file.exists()) {
      final byteData =
          await DefaultAssetBundle.of(context).load("assets/Qaloun13v2.pdf");
      final bytes = byteData.buffer.asUint8List();
      await file.writeAsBytes(bytes, flush: true);
    }

    return file;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: CustomAppBar(
        onThemeChanged: () {
          setState(() {
            _isNightMode = !_isNightMode; // Bascule entre mode jour et nuit
          });
        },
        isNightMode: _isNightMode, // Passez l'état du mode nuit ici
        onBookmarkPressed:
            _toggleBookmark, // Ajout du comportement du marque-page
        isBookmarked: _isBookmarked,
        scaffoldKey: _scaffoldKey,
      ),
      drawer: CustomDrawer(
        isNightMode: _isNightMode,
        onToggleNightMode: () {
          setState(() {
            _isNightMode = !_isNightMode;
          });
        },
      ),
      body: Column(
        children: [
          Expanded(
            child: _pdfPath.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : Directionality(
                    textDirection: TextDirection.rtl,
                    child: ColorFiltered(
                      colorFilter: _isNightMode
                          ? const ColorFilter.matrix(<double>[
                              -1, 0, 0, 0, 255, // Rouge inversé
                              0, -1, 0, 0, 255, // Vert inversé
                              0, 0, -1, 0, 255, // Bleu inversé
                              0, 0, 0, 1, 0, // Alpha inchangé
                            ])
                          : const ColorFilter.mode(
                              Colors.transparent, BlendMode.color),
                      child: PDFView(
                        filePath: _pdfPath,
                        swipeHorizontal: true,
                        onRender: (pages) {
                          setState(() {
                            _totalPages = pages!;
                            _currentPage = _totalPages - 1;
                          });
                          _pdfViewController?.setPage(_currentPage);
                        },
                        onViewCreated: (controller) {
                          _pdfViewController = controller;
                          // Naviguez à la page sauvegardée si elle existe

                          if (_savedPage != null) {
                            controller.setPage(_savedPage!);
                            setState(() {
                              _currentPage = _savedPage!;
                              _isBookmarked = true;
                            });
                          }
                        },
                        onPageChanged: (current, total) {
                          setState(() {
                            _currentPage = total! - current! - 1;
                          });
                          _syncCurrentPage(_currentPage);
                        },
                      ),
                    ),
                  ),
          ),
          Container(
            color: _isNightMode ? Colors.black : Colors.grey[200],
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return SouraListDialog(
                          sourates: _sourates,
                          onSouraSelected: (sourateName, pageIndex) {
                            _pdfViewController?.setPage(pageIndex);
                            setState(() {
                              _currentPage = pageIndex;
                              _currentSourate = sourateName;
                            });
                            _syncCurrentPage(pageIndex);
                          },
                        );
                      },
                    );
                  },
                  child: Text(
                    _currentSourate,
                    style: TextStyle(
                      fontSize: 25.0,
                      color: _isNightMode ? Colors.white : AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => showPageSearchDialog(
                    context,
                    _totalPages,
                    (page) {
                      _pdfViewController?.setPage(page);
                      setState(() {
                        _currentPage = page;
                      });
                    },
                  ),
                  child: Text(
                    '${_currentPage + 1}',
                    style: TextStyle(
                      fontSize: 25.0,
                      color: _isNightMode ? Colors.white : AppColors.primary,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return HizbSearchDialog(
                          ahzab: _ahzab,
                          onPageSelected: (page) {
                            _pdfViewController?.setPage(page);
                            setState(() {
                              _currentPage = page;
                            });
                          },
                          onHizbUpdated: (hizb) {
                            setState(() {
                              _currentHizb = hizb;
                            });
                            _syncCurrentPage(_currentPage);
                          },
                        );
                      },
                    );
                  },
                  child: Text(
                    'الحزب $_currentHizb',
                    style: TextStyle(
                      fontSize: 25.0,
                      color: _isNightMode ? Colors.white : AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _syncCurrentPage(int currentPage) {
    String? currentSoura;
    int? currentHizb;

    print("pageeeeeeeee: $currentPage");
    // Vérifiez si la page actuelle est sauvegardée
    setState(() {
      _isBookmarked = (_savedPage == currentPage);
    });
    // Trouver la sourate correspondant à la page actuelle
    for (var entry in _sourates.entries) {
      String name = entry.key;
      List<int> range = entry.value;
      if (currentPage >= range[0] - 1 && currentPage <= range[1] - 1) {
        print("name: $name");
        currentSoura = name;
        print("curent name: $currentSoura");
        break; 
      }
    }

    // Trouver le hizb correspondant à la page actuelle
    for (var entry in _ahzab.entries) {
      int hizb = entry.key;
      List<int> range = entry.value;
      if (currentPage >= range[0] - 1 && currentPage <= range[1] - 1) {
        print("hizb: $hizb");
        currentHizb = hizb;
        print("current Hizb: $currentHizb");

        break;
      }
    }

    setState(() {
      // Si une correspondance est trouvée, mettez à jour, sinon conservez les valeurs actuelles
      if (currentSoura != null) _currentSourate = currentSoura;
      if (currentHizb != null) _currentHizb = currentHizb;
    });

    print(
        "Sourate actuelle : $_currentSourate, Page : $currentPage, Hizb : $_currentHizb");
  }

  void _toggleBookmark() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      if (_isBookmarked) {
        _savedPage = null; 
      } else {
        _savedPage = _currentPage; 
      }
      _isBookmarked = !_isBookmarked;
    });

    if (_savedPage != null) {
      await prefs.setInt('savedPage', _savedPage!); 
    } else {
      await prefs.remove('savedPage'); 
    }
  }
}
