import 'package:flutter/material.dart';

class Themes {
  static ThemeData dark = ThemeData(
    primarySwatch: Colors.blueGrey,
    fontFamily: 'Allison',
    brightness: Brightness.dark,
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: Colors.orange,
      selectionHandleColor: Colors.orange,
      selectionColor: Colors.orange,
    ),
  );

  static ThemeData light = ThemeData(
    primarySwatch: Colors.blueGrey,
    fontFamily: 'Allison',
    brightness: Brightness.light,
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: Colors.orange,
      selectionHandleColor: Colors.orange,
      selectionColor: Colors.orange,
    ),
  );
}
