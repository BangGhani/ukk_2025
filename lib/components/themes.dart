import 'package:flutter/material.dart';

class ThemeColor {
  static const Color hijau = Color.fromARGB(255, 64, 170, 84);
  static const Color hitam = Color.fromARGB(255, 28, 26, 29);
  static const Color putih = Color.fromARGB(255, 248, 250, 252);
  static const Color background = Color.fromARGB(255, 228, 228, 228);
  static const Color abu = Color.fromARGB(255, 105, 113, 121);
}


class ThemeSize {
  static const double margin = 15;
  static const double padding = 15;

  static BorderRadius borderRadius = BorderRadius.circular(15);
}

class ThemeComponent {
  static ThemeData get defaultTheme {
    return ThemeData(
      colorSchemeSeed: ThemeColor.hijau,
      fontFamily: "Gilroy",
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: ThemeColor.abu),
        bodyMedium: TextStyle(color: ThemeColor.abu),
      ),

      scaffoldBackgroundColor: Colors.white,
      brightness: Brightness.light,

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: ThemeColor.hijau,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.all(ThemeSize.padding),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: ThemeSize.borderRadius,
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.all(ThemeSize.padding),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: ThemeSize.borderRadius,
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          textStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: 'Gilroy',
          ),
        ),
      ),
      inputDecorationTheme: defaultInputDecorationTheme,
    );
  }

  static const defaultInputDecorationTheme = InputDecorationTheme(
      fillColor: ThemeColor.putih,
      floatingLabelBehavior: FloatingLabelBehavior.never,
      border: OutlineInputBorder(
        borderSide: BorderSide(width: 0.1),
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(width: 0.1),
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(width: 0.1), 
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      suffixIconColor: ThemeColor.abu,
  );
}