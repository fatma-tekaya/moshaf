import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import '../widgets/page_search_dialog.dart';
import '../widgets/soura_search_dialog.dart';
import '../widgets/hzb_search_dialog.dart';
import '../utils/constants.dart';
import '../utils/colors.dart';

class PdfHomePage extends StatefulWidget {
  const PdfHomePage({Key? key}) : super(key: key);

  @override
  _PdfHomePageState createState() => _PdfHomePageState();
}

class _PdfHomePageState extends State<PdfHomePage> {
  String _pdfPath = "";
  int _totalPages = 0;
  int _currentPage = 0;
  String _currentSourate = "الفاتحة";
  int _currentHizb = 1;

  PDFViewController? _pdfViewController;
  final Map<String, int> _sourates = sourates;
  final Map<int, int> _ahzab = ahzab;
  @override
  void initState() {
    super.initState();
    _loadPdf();
  }

  Future<void> _loadPdf() async {
    final pdfFile = await _copyPdfFromAssets();
    setState(() {
      _pdfPath = pdfFile.path;
    });
  }

  Future<File> _copyPdfFromAssets() async {
    final dir = await getTemporaryDirectory();
    final file = File("${dir.path}/Qaloun13v1.pdf");

    if (!await file.exists()) {
      final byteData =
          await DefaultAssetBundle.of(context).load("assets/Qaloun13v1.pdf");
      final bytes = byteData.buffer.asUint8List();
      await file.writeAsBytes(bytes, flush: true);
    }

    return file;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('المصحف الشريف'),
      ),
      body: Column(
        children: [
          Expanded(
            child: _pdfPath.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : Directionality(
                    textDirection: TextDirection.rtl,
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
                      },
                      onPageChanged: (current, total) {
                        setState(() {
                          _currentPage = total! - current! - 1;
                        });
                      },
                    ),
                  ),
          ),
          Container(
            color: Colors.grey[200],
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
                          },
                        );
                      },
                    );
                  },
                  child: Text(
                    _currentSourate,
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
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
                      fontSize: 16.0,
                      decoration: TextDecoration.none,
                      color: AppColors.primary,
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
                          },
                        );
                      },
                    );
                  },
                  child: Text(
                    'الحزب $_currentHizb',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
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
}
