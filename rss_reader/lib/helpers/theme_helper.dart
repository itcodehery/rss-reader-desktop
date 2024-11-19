import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ThemeHelper {
  ThemeData lightTheme(MaterialColor color) {
    return ThemeData(
        primarySwatch: color,
        colorScheme: ColorScheme.light(
          primary: color,
          secondary: color[100]!,
        ),
        scaffoldBackgroundColor: Colors.white,
        useMaterial3: true,
        textTheme: GoogleFonts.dmSansTextTheme(),
        brightness: Brightness.light);
  }

  ThemeData darkTheme(MaterialColor color) {
    return ThemeData(
        primarySwatch: color,
        colorScheme: ColorScheme.dark(
          primary: color,
          secondary: color[100]!,
        ),
        scaffoldBackgroundColor: Colors.black,
        useMaterial3: true,
        textTheme: GoogleFonts.dmSansTextTheme(),
        brightness: Brightness.dark);
  }

  List<MaterialColor> get colorOptions => [
        Colors.orange,
        Colors.blue,
        Colors.green,
        Colors.purple,
        Colors.red,
        Colors.teal,
        Colors.pink,
        Colors.amber,
        Colors.cyan,
        Colors.indigo,
      ];
}
