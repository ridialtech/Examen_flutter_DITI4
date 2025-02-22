import 'package:flutter/material.dart';
import 'produit_page.dart';

void main() {
  runApp(const MyApp());
}

/// Convertit une [Color] en [MaterialColor] pour l'utiliser comme primarySwatch.
MaterialColor createMaterialColor(Color color) {
  List<double> strengths = <double>[.05];
  final swatch = <int, Color>{};
  final r = color.red, g = color.green, b = color.blue;

  for (int i = 1; i < 10; i++) {
    strengths.add(0.1 * i);
  }
  for (var strength in strengths) {
    final ds = 0.5 - strength;
    swatch[(strength * 1000).round()] = Color.fromRGBO(
      r + ((ds < 0 ? r : (255 - r)) * ds).round(),
      g + ((ds < 0 ? g : (255 - g)) * ds).round(),
      b + ((ds < 0 ? b : (255 - b)) * ds).round(),
      1,
    );
  }
  return MaterialColor(color.value, swatch);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final primaryColor = const Color(0xFF1177FF); // Couleur principale (#17f en notation complète)

    return MaterialApp(
      title: 'Gestion de Produits',
      theme: ThemeData(
        primarySwatch: createMaterialColor(primaryColor),
      ),
      home: const ProduitPage(),
    );
  }
}
