import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'dart:io';
import '../widgets/page_search_dialog.dart';
import '../widgets/ayah_search.dart';
import '../widgets/CustomAppBar.dart';
import '../widgets/CustomDrawer.dart';
import '../widgets/soura_search_dialog.dart';
import '../widgets/hzb_search_dialog.dart';
import '../utils/constants.dart';
import '../utils/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
// import 'package:pdfx/pdfx.dart';
// import 'package:share_plus/share_plus.dart';
// import 'dart:ui' as ui;
// import 'dart:typed_data';
// import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

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
    _savedPage = prefs.getInt('lastSavedPage');
    final pdfFile = await _copyPdfFromAssets();

    setState(() {
      _pdfPath = pdfFile.path;
      if (_savedPage != null) {
        _currentPage = _savedPage!;
        _isBookmarked = true;
      } else {
        _currentPage = 0; // ⬅️ This ensures reset if no saved page
        _isBookmarked = false;
      }
    });
    // Navigate to saved page after delay
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_pdfViewController != null && _totalPages > 0) {
        final physicalPage = _totalPages - _currentPage - 1;
        _pdfViewController?.setPage(physicalPage);
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
      resizeToAvoidBottomInset: false,
      key: _scaffoldKey,
      appBar: CustomAppBar(
        onThemeChanged: () {
          setState(() {
            _isNightMode = !_isNightMode;
          });
        },
        context: context,
        // onSharePressed: () async {
        //   await shareCurrentPage(
        //       _currentPage + 1, _pdfPath); // +1 because pages are 1-based
        // },

        isNightMode: _isNightMode,
        onBookmarkPressed: _toggleBookmark,
        isBookmarked: _isBookmarked,
        scaffoldKey: _scaffoldKey,
        currentPage: _currentPage, // Pass current page
        currentSourate: _currentSourate, // Pass current Surah name
        onSearchPressed: () async {
          final verses = await AyahSearch.loadQuranData(context);
          AyahSearch.showAyahSearchDialog(context, verses, (selectedPage) {
            _pdfViewController?.setPage(_totalPages - selectedPage - 1);
            setState(() {
              _currentPage = selectedPage;
            });
          });
        },
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
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CircularProgressIndicator(),
                      const SizedBox(height: 10),
                      Text(
                        "جارٍ تحميل الملف...",
                        style: TextStyle(
                          fontSize:
                              MediaQuery.of(context).size.width * 0.05 > 22
                                  ? MediaQuery.of(context).size.width * 0.05
                                  : 22,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  )
                : Directionality(
                    textDirection: TextDirection.rtl,
                    child: ColorFiltered(
                      colorFilter: _isNightMode
                          ? const ColorFilter.matrix(<double>[
                              -1.0, 0.0, 0.0, 0.0, 255.0, //
                              0.0, -1.0, 0.0, 0.0, 255.0, //
                              0.0, 0.0, -1.0, 0.0, 255.0, //
                              0.0, 0.0, 0.0, 1.0, 0.0, //
                            ])
                          : const ColorFilter.matrix(<double>[
                              1.0, 0.0, 0.0, 0.0, 0.0, //
                              0.0, 1.0, 0.0, 0.0, 0.0, //
                              0.0, 0.0, 1.0, 0.0, 0.0, //
                              0.0, 0.0, 0.0, 1.0, 0.0, //klpjol::m:m:
                            ]),
                      child: PDFView(
                        filePath: _pdfPath,
                        autoSpacing: true,
                        swipeHorizontal: true,
                        enableSwipe: true,
                        fitPolicy: FitPolicy.BOTH,
                        onRender: (pages) {
                          setState(() {
                            _totalPages = pages!;
                            //print('here savedpage $_savedPage');
                            if (_savedPage != null) {
                              _currentPage = _savedPage!;
                              _pdfViewController
                                  ?.setPage(_totalPages - _currentPage - 1);
                            } else {
                              // print('hallo $_currentPage');
                              _currentPage = 0;
                              _pdfViewController?.setPage(_currentPage);
                            }
                          });
                        },
                        onViewCreated: (controller) {
                          _pdfViewController = controller;
                          if (_currentPage != null) {
                            int physicalPage = _totalPages - _currentPage - 1;
                            Future.delayed(const Duration(milliseconds: 500),
                                () {
                              if (physicalPage >= 0 &&
                                  _pdfViewController != null) {
                                _pdfViewController?.setPage(physicalPage);
                              }
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
                    //),
                  ),
          ),
          Container(
            color:
                _isNightMode ? AppColors.textPrimary : AppColors.textSecondary,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: TextButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return SouraListDialog(
                            sourates: _sourates,
                            onSouraSelected: (sourateName, pageIndex) {
                              _pdfViewController
                                  ?.setPage(_totalPages - pageIndex - 1);
                              setState(() {
                                _currentPage = pageIndex;
                                _currentSourate = sourateName;
                              });
                              _syncCurrentPage(pageIndex);
                            },
                            isNightMode: _isNightMode,
                          );
                        },
                      );
                    },
                    style: TextButton.styleFrom(
                      backgroundColor:
                          _isNightMode ? Colors.black : Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      _currentSourate,
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.05 > 22
                            ? MediaQuery.of(context).size.width * 0.05
                            : 22,
                        color: _isNightMode ? Colors.white : AppColors.primary,
                      ),
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
                      });
                    },
                    _isNightMode,
                  ),
                  child: Text(
                    '${_currentPage + 1}',
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.06 > 22
                          ? MediaQuery.of(context).size.width *
                              0.06 // Taille relative
                          : 25,
                      color: _isNightMode ? Colors.white : AppColors.primary,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
                Flexible(
                  child: TextButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return HizbSearchDialog(
                            data: data,
                            onPageSelected: (page) {
                              _pdfViewController
                                  ?.setPage(_totalPages - page - 1);
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
                            isNightMode: _isNightMode,
                          );
                        },
                      );
                    },
                    style: TextButton.styleFrom(
                      backgroundColor:
                          _isNightMode ? Colors.black : Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'الحِزب $_currentHizb',
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.05 > 22
                            ? MediaQuery.of(context).size.width * 0.05
                            : 22,
                        color: _isNightMode ? Colors.white : AppColors.primary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
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

  void _toggleBookmark(String sourate, int page) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> savedPages = prefs.getStringList('savedPages') ?? [];

    final String date = DateTime.now().toIso8601String().split('T')[0];
    final String newEntry = '$date|$sourate|$page';

    setState(() {
      if (savedPages.contains(newEntry)) {
        savedPages.remove(newEntry);
        _isBookmarked = false;

        // Remove lastSavedPage only if it's this page
        if (prefs.getInt('lastSavedPage') == page) {
          prefs.remove('lastSavedPage');
        }
      } else {
        savedPages.add(newEntry);
        _isBookmarked = true;
        prefs.setInt('lastSavedPage', page); // update only when adding
      }
    });

    await prefs.setStringList('savedPages', savedPages);
  }

// Future<void> shareCurrentPage(int pageNumber, String pdfPath) async {
//   final dynamicLinkParams = DynamicLinkParameters(
//     uriPrefix: 'https://yourprefix.page.link', // Replace with your own
//     link: Uri.parse('https://example.com/page?page=$pageNumber'),
//     androidParameters: AndroidParameters(
//       packageName: 'com.example.yourapp',
//       minimumVersion: 1,
//     ),
//     socialMetaTagParameters: SocialMetaTagParameters(
//       title: 'المصحف الشريف',
//       description: 'الصفحة رقم $pageNumber',
//     ),
//   );

//   final shortLink =
//       await FirebaseDynamicLinks.instance.buildShortLink(dynamicLinkParams);

//   await Share.share(
//     'صفحة $pageNumber من المصحف الشريف:\n${shortLink.shortUrl}',
//   );
// }
}
