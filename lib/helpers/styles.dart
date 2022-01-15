import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Styles {
  static final colors = _Colors();
  static final textStyles = _TextStyles();
}

class _Colors {
  final themeColor = const Color(0XFF1d2438);
  final primaryColor = const MaterialColor(0XFF1d2438, {
    50: Color(0XFF1d2438),
    100: Color(0XFF1d2438),
    200: Color(0XFF1d2438),
    300: Color(0XFF1d2438),
    400: Color(0XFF1d2438),
    500: Color(0XFF1d2438),
    600: Color(0XFF1d2438),
    700: Color(0XFF1d2438),
    800: Color(0XFF1d2438),
    900: Color(0XFF1d2438),
  });
  final black = Colors.black;
  final white = Colors.white;
}

class _TextStyles {
  final f14Regular = TextStyle(
      fontSize: 14,
      color: Styles.colors.black,
      fontFamily: GoogleFonts.nunito().copyWith().fontFamily);
  final f14 = TextStyle(
      fontSize: 14,
      color: Styles.colors.black,
      fontWeight: FontWeight.bold,
      fontFamily: GoogleFonts.nunito().copyWith().fontFamily);
}
