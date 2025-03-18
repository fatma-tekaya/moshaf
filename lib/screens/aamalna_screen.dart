import 'package:flutter/material.dart';
import 'package:moshaf/utils/colors.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class AamalnaScreen extends StatefulWidget {
  const AamalnaScreen({super.key});

  @override
  _AamalnaScreenState createState() => _AamalnaScreenState();
}

class _AamalnaScreenState extends State<AamalnaScreen> {
  final PageController _pageController = PageController(); // Contrôleur du PageView
  final List<String> _images = [
    'assets/aamalna1.jpg',
    'assets/aamalna2.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: const Text(
        //   'أعمالنا',
        //   textAlign: TextAlign.right,
        //   style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        // ),
        backgroundColor: AppColors.primary,
      ),
      body: Stack(
        children: [
          // PageView en plein écran
          PageView.builder(
            controller: _pageController,
            itemCount: _images.length,
            itemBuilder: (context, index) {
              return SizedBox.expand( // Remplit tout l’écran
                child: Image.asset(
                  _images[index],
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.fill, 
                ),
              );
            },
          ),

          // Ajout du SmoothPageIndicator SUR l’image
          Positioned(
            bottom: 20, // Place l’indicateur en bas de l’image
            left: 0,
            right: 0,
            child: Center(
              child: SmoothPageIndicator(
                controller: _pageController,
                count: _images.length,
                effect: ExpandingDotsEffect(
                  activeDotColor: Colors.orange, // Couleur active
                  dotColor: Colors.white, // Couleur semi-transparente
                  dotHeight: 12,
                  dotWidth: 12,
                  spacing: 8,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
