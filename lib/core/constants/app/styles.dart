import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class Styles {
  static final colors = _Colors();
  static final textStyles = _TextStyles();
}

class _Colors {
  final primaryColor = getMaterialColorFromColor(const Color(0xffADD8E6));
  final primaryColorDark = getMaterialColorFromColor(const Color(0xff1d2438));
  final purple = getMaterialColorFromColor(const Color(0xff261757));
  final black = Colors.black;
  final white = Colors.white;
  final backgroundGrey = const Color(0xff212121);

  static Color getShade(Color color, {bool darker = false, double value = .1}) {
    assert(value >= 0 && value <= 1);
    final hsl = HSLColor.fromColor(color);
    final hslDark = hsl.withLightness(
        (darker ? (hsl.lightness - value) : (hsl.lightness + value))
            .clamp(0.0, 1.0));
    return hslDark.toColor();
  }

  static MaterialColor getMaterialColorFromColor(Color color) {
    Map<int, Color> colorShades = {
      50: getShade(color, value: 0.5),
      100: getShade(color, value: 0.4),
      200: getShade(color, value: 0.3),
      300: getShade(color, value: 0.2),
      400: getShade(color, value: 0.1),
      500: color, //Primary value
      600: getShade(color, value: 0.1, darker: true),
      700: getShade(color, value: 0.15, darker: true),
      800: getShade(color, value: 0.2, darker: true),
      900: getShade(color, value: 0.25, darker: true),
    };
    return MaterialColor(color.value, colorShades);
  }
}

class _TextStyles {
  final f14Regular = Theme.of(Get.context!).textTheme.titleLarge?.copyWith(
      fontSize: 14, fontFamily: GoogleFonts.nunito().copyWith().fontFamily);
  final f14Bold = Theme.of(Get.context!).textTheme.titleLarge?.copyWith(
      fontSize: 14,
      fontWeight: FontWeight.bold,
      fontFamily: GoogleFonts.nunito().copyWith().fontFamily);
}
