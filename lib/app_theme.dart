
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    primarySwatch: Colors.deepPurple,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    textTheme: GoogleFonts.robotoTextTheme(),
    appBarTheme: AppBarTheme(
      centerTitle: true,
      titleTextStyle: GoogleFonts.oswald(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Colors.grey.withAlpha(128),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        textStyle: GoogleFonts.roboto(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
    ),
  );
}
