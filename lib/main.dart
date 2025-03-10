import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'utils/colors.dart';
import 'screens/home_page.dart';
import 'screens/splash_screen.dart';
import 'package:flutter/services.dart';
void main() {
  WidgetsFlutterBinding.ensureInitialized(); 
 runApp(const MyApp());
   SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp, // Locks in Portrait mode
  ]).then((_) {
    runApp(MyApp());
  });
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.system; // Mode par défaut : thème système

  void _toggleTheme() {
    setState(() {
      _themeMode =
          _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'المصحف الشريف',
      theme: ThemeData(
        fontFamily: 'almushaf',
        colorScheme: const ColorScheme.light(
          primary: AppColors.primary,
          surface: Colors.white,
          onPrimary: Colors.white,
          onSurface: Colors.black,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
        ),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        scaffoldBackgroundColor: AppColors.textPrimary,
        colorScheme: const ColorScheme.dark(
          primary: AppColors.primary,
          surface: Colors.black,
          onPrimary: Colors.black,
          onSurface: Colors.white,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
        ),
        useMaterial3: true,
      ),
      themeMode: _themeMode, // Applique le thème sélectionné
      locale: const Locale('ar'),
      supportedLocales: const [
        Locale('ar'), // Arabe
        Locale('en'), // Anglais
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      initialRoute: '/', // Route initiale
      routes: {
        '/': (context) => const SplashScreen(), // Splash Screen
        '/home': (context) => PdfHomePage(
              onThemeChanged: _toggleTheme, // Passer le toggle au HomePage
            ),
        
      },
    );
  }
}
