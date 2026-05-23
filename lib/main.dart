import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/age_calculator_screen.dart';
import 'screens/zodiac_screen.dart';
import 'screens/bmi_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DevTygers App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1565C0),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1565C0),
          foregroundColor: Colors.white,
          elevation: 4,
        ),
        drawerTheme: const DrawerThemeData(backgroundColor: Color(0xFF0D47A1)),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/age': (context) => const AgeCalculatorScreen(),
        '/zodiac': (context) => const ZodiacScreen(),
        '/bmi': (context) => const BmiScreen(),
      },
    );
  }
}
