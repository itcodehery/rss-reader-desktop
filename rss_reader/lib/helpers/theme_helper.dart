import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final lightTheme = ThemeData(
    primarySwatch: Colors.orange,
    scaffoldBackgroundColor: Colors.white,
    useMaterial3: true,
    textTheme: GoogleFonts.dmSansTextTheme(),
    brightness: Brightness.light);

final darkTheme = ThemeData(
    primarySwatch: Colors.deepOrange,
    scaffoldBackgroundColor: Colors.black,
    useMaterial3: true,
    textTheme: GoogleFonts.dmSansTextTheme(),
    brightness: Brightness.dark);
