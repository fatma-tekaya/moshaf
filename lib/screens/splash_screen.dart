import 'package:flutter/material.dart';
import 'dart:async';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Temporisateur pour rediriger vers la page principale
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, '/home');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        // Image de fond
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/splash.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        // Logos et textes superposés
        Padding(
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).size.height * 0.35,
            left: 16.0,
            right: 16.0,
          ),
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'المؤسسات المشاركة',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.brown,
                ),
              ),
              const SizedBox(height: 20),
              // Grille des logos
              GridView.count(
                crossAxisCount: 2, // Deux colonnes
                shrinkWrap: true, // Permet à la grille de s'adapter au contenu
                mainAxisSpacing: 10, // Espacement vertical
                crossAxisSpacing: 10, // Espacement horizontal
                padding: const EdgeInsets.all(16),
                children: [
                  buildLogoItem('assets/logo11.png', 'المؤسسة الأولى'),
                  buildLogoItem('assets/logo22.png', 'المؤسسة الثانية'),
                  buildLogoItem('assets/logo33.png', 'المؤسسة الثالثة'),
                  buildLogoItem('assets/logo44.png', 'المؤسسة الرابعة'),
                ],
              ),
            ],
          ),
        ),
      ]),
    );
  }

  // Widget pour chaque logo avec son texte
  Widget buildLogoItem(String imagePath, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
          ),
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Image.asset(
              imagePath,
              fit: BoxFit.contain,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.brown,
          ),
        ),
      ],
    );
  }
}
