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
  int? _savedPage; 
  bool _isBookmarked = false;
  String _pdfPath = "";
  int _totalPages = 604;
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
    _savedPage = prefs.getInt('savedPage'); 
    final pdfFile = await _copyPdfFromAssets();
    setState(() {
      _pdfPath = pdfFile.path;
      if (_savedPage != null) {
      _currentPage = _savedPage!;
      _isBookmarked = true;
    } else {
      _currentPage = _totalPages; 
    }
    });
  }

  Future<File> _copyPdfFromAssets() async {
    final dir = await getTemporaryDirectory();
    final file = File("${dir.path}/qualounn.pdf");

    if (!await file.exists()) {
      final byteData =
          await DefaultAssetBundle.of(context).load("assets/qualounn.pdf");
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
            _isNightMode = !_isNightMode; 
          });
        },
        isNightMode: _isNightMode, 
        onBookmarkPressed:
            _toggleBookmark,
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
                            if (_savedPage != null) {
                              _currentPage = _savedPage!;
                              print("saved page not null $_savedPage");
                              _pdfViewController?.setPage(_totalPages - _currentPage - 1);
                            } else {
                              //_currentPage = 0;
                              _currentPage = _totalPages;
                              _pdfViewController?.setPage(_currentPage);
                            }
                            print("on render $_currentPage");
                          });
                        },
                        onViewCreated: (controller) {
                          _pdfViewController = controller;
                          if (_savedPage != null) {
                             print("on view created $_savedPage et $_isBookmarked");
                            int physicalPage = _totalPages - _savedPage! - 1;
                            print("test $physicalPage");
                            controller.setPage(physicalPage);
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
                          print("on page changed $_currentPage");
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
                            _pdfViewController?.setPage(_totalPages - pageIndex - 1);
                            setState(() {
                              _currentPage = pageIndex;
                              _currentSourate = sourateName;
                            });
                            print("soura search $_currentPage");
                            _syncCurrentPage(pageIndex);
                          },
                          isNightMode: _isNightMode,
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
                      _pdfViewController?.setPage(_totalPages - page - 1);
                      setState(() {
                        _currentPage = page;
                        print("page searched $_currentPage");
                      });
                    },
                    _isNightMode,
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
                            _pdfViewController?.setPage(_totalPages - page - 1);
                            setState(() {
                              _currentPage = page;
                              print("hzb searched $_currentPage");
                            });
                          },
                          onHizbUpdated: (hizb) {
                            setState(() {
                              _currentHizb = hizb;
                            });
                            _syncCurrentPage(_currentPage);
                          },
                          isNightMode: _isNightMode,
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
    setState(() {
      _isBookmarked = (_savedPage == currentPage);
      print("this book marked $_isBookmarked");
    });
    for (var entry in _sourates.entries) {
      String name = entry.key;
      List<int> range = entry.value;
      if (currentPage >= range[0] - 1 && currentPage <= range[1] - 1) {
        currentSoura = name;
        break;
      }
    }

    for (var entry in _ahzab.entries) {
      int hizb = entry.key;
      List<int> range = entry.value;
      if (currentPage >= range[0] - 1 && currentPage <= range[1] - 1) {
        currentHizb = hizb;
        break;
      }
    }
    setState(() {
      // Si une correspondance est trouvée, mettez à jour, sinon conservez les valeurs actuelles
      if (currentSoura != null) _currentSourate = currentSoura;
      if (currentHizb != null) _currentHizb = currentHizb;
    });
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
