import 'package:flutter/material.dart';
import 'dart:async';

import 'package:moshaf/utils/colors.dart';

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
    Timer(const Duration(seconds: 4), () {
      Navigator.pushReplacementNamed(context, '/home');
    });
  }

 @override
Widget build(BuildContext context) {
  return Scaffold(
    body: Stack(
      children: [
        // Image de fond
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/splash.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        // Contenu défilable
        SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).size.height * 0.35,
              left: 16.0,
              right: 16.0,
            ),
            child: Column(
              children: [
                Text(
                  'المؤسسات المشاركة',
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.06,
                    color: AppColors.primary,
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
                  physics: const NeverScrollableScrollPhysics(), // Désactive le défilement interne
                  children: [
                    buildLogoItem('assets/logo11.png', 'مركز الإمام ابن عرفة'),
                    buildLogoItem('assets/logo22.png', 'المركز العربى للكتاب'),
                    buildLogoItem('assets/logo33.png', 'معهد الإمام المارغني للقراءات'),
                    buildLogoItem('assets/logo44.png', 'دار الإمام ابن عرفة '),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}


  // Widget pour chaque logo avec son texte
  Widget buildLogoItem(String imagePath, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 0.2, 
          height: MediaQuery.of(context).size.width * 0.2,
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
          style: TextStyle(
            fontSize: MediaQuery.of(context).size.width * 0.05,
            color: AppColors.primary,
          ),
        ),
      ],
    );
  }
}
