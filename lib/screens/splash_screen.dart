import 'package:flutter/material.dart';
import 'dart:async';

import '../utils/colors.dart';

class SplashScreen extends StatefulWidget {
  final bool redirectToHome;
  const SplashScreen({super.key, this.redirectToHome = true});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    if (widget.redirectToHome) {
      Timer(const Duration(seconds: 4), () {
        Navigator.pushReplacementNamed(context, '/home');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isPortrait = screenHeight < screenWidth;

    return Scaffold(
      backgroundColor: AppColors.cardBackground,
      body: Stack(
        children: [
          // Main content with scrollable area
          Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // Header with background image
                      Container(
                        width: screenWidth,
                        height: isPortrait ? screenHeight * 0.6  : screenHeight * 0.35,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/header.png'),
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        "المؤسسات المشاركة",
                        style: TextStyle(
                          fontSize: screenWidth * 0.06,
                          fontWeight: FontWeight.bold,
                          color: Colors.brown.shade700,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
                        child: GridView.count(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisCount: 2,
                          childAspectRatio: 1,
                          crossAxisSpacing: 20,
                          mainAxisSpacing: 20,
                          children: [
                            OrganizationWidget(
                                image: 'assets/logo11.png', name: "مركز الإمام ابن عرفة"),
                            OrganizationWidget(
                                image: 'assets/logo22.png', name: "المركز العربى للكتاب"),
                            OrganizationWidget(
                                image: 'assets/logo33.png', name: "معهد الإمام المارغني"),
                            OrganizationWidget(
                                image: 'assets/logo44.png',
                                name: "دار الإمام ابن عرفة"),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Dream Catcher Image Fixed at Bottom-Left
          if(!isPortrait)
          Positioned(
            bottom: 0,
            left: 0,
            child: Image.asset(
              'assets/catcher.png', // Ensure the asset path is correct
              width: screenWidth * 0.4, // Adjust width as needed
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }
}

// Organization Widget
class OrganizationWidget extends StatelessWidget {
  final String image;
  final String name;

  const OrganizationWidget({super.key, required this.image, required this.name});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Column(
      children: [
        Container(
          width: screenWidth * 0.25,
          height: screenWidth * 0.25,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 4,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: ClipOval(
              child: Image.asset(
                image,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          name,
          style: TextStyle(
            fontSize: screenWidth * 0.05,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
