import 'package:flutter/material.dart';
import 'package:flutter_tesseract_ocr/flutter_tesseract_ocr.dart';
import 'package:flutter/services.dart';
import 'dart:io'; // Pour manipuler les fichiers locaux

class TesseractOCRPage extends StatefulWidget {
  const TesseractOCRPage({super.key});

  @override
  _TesseractOCRPageState createState() => _TesseractOCRPageState();
}

class _TesseractOCRPageState extends State<TesseractOCRPage> {
  String _extractedText = 'Aucun texte détecté.';
  File? _imageFile; // Pour afficher l'image temporaire

  @override
  void initState() {
    super.initState();
    _processOCR(); // Démarrer l'OCR au lancement
  }

  Future<void> _processOCR() async {
    try {
      // Charger l'image des assets
      final byteData = await rootBundle.load('assets/img2.png');
      final tempDir = await Directory.systemTemp.createTemp();
      final tempFile = File('${tempDir.path}/img2.png');
      await tempFile.writeAsBytes(byteData.buffer.asUint8List());

      // Vérifiez que le fichier temporaire est bien créé
      if (!await tempFile.exists()) {
        setState(() {
          _extractedText = 'Erreur : Le fichier temporaire n\'a pas pu être créé.';
        });
        return;
      }

      setState(() {
        _imageFile = tempFile; // Mettre à jour le fichier temporaire pour l'affichage
      });

      // Utiliser Tesseract pour l'OCR
      final String text = await FlutterTesseractOcr.extractText(
        tempFile.path,
        language: 'ara', // Langue utilisée pour l'OCR
        args: {
          'psm': '11', // Mode de segmentation des pages
          'tessdata_config': 'assets/tessdata_config.json', // Configuration JSON
        },
      );

      // Vérifiez si le texte retourné est null
      setState(() {
        _extractedText = text.isNotEmpty == true ? text : 'Aucun texte détecté.';
      });
    } catch (e) {
      setState(() {
        _extractedText = 'Erreur : $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('OCR avec Tesseract'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (_imageFile != null)
              Column(
                children: [
                  Image.file(
                    _imageFile!,
                    height: 300,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(height: 16.0),
                ],
              ),
            const Text(
              'Texte extrait :',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  _extractedText,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
