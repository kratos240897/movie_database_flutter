import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie_database/core/service/theme_service.dart';

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
  TextStyle f10Regular({String? fontFamily, Color? color}) => TextStyle(
      fontWeight: FontWeight.normal,
      fontSize: 10.sp,
      color:
          color ?? (ThemeService().isDarkMode() ? Colors.white : Colors.black));

  TextStyle f10SemiBold({String? fontFamily, Color? color}) =>
      TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w600, color:
          color ?? (ThemeService().isDarkMode() ? Colors.white : Colors.black));

  TextStyle f10Bold({String? fontFamily, Color? color}) =>
      TextStyle(fontSize: 10.sp, fontWeight: FontWeight.bold, color:
          color ?? (ThemeService().isDarkMode() ? Colors.white : Colors.black));

  TextStyle f12Regular({String? fontFamily, Color? color}) =>
      TextStyle(fontWeight: FontWeight.normal, fontSize: 12.sp, color:
          color ?? (ThemeService().isDarkMode() ? Colors.white : Colors.black));

  TextStyle f12SemiBold({String? fontFamily, Color? color}) =>
      TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600, color:
          color ?? (ThemeService().isDarkMode() ? Colors.white : Colors.black));

  TextStyle f12Bold({String? fontFamily, Color? color}) =>
      TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold, color:
          color ?? (ThemeService().isDarkMode() ? Colors.white : Colors.black));

  TextStyle f14Regular({String? fontFamily, Color? color}) =>
      TextStyle(fontWeight: FontWeight.normal, fontSize: 14.sp, color:
          color ?? (ThemeService().isDarkMode() ? Colors.white : Colors.black));

  TextStyle f14SemiBold({String? fontFamily, Color? color}) =>
      TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600, color:
          color ?? (ThemeService().isDarkMode() ? Colors.white : Colors.black));

  TextStyle f14Bold({String? fontFamily, Color? color}) =>
      TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold, color:
          color ?? (ThemeService().isDarkMode() ? Colors.white : Colors.black));

  TextStyle f16Regular({String? fontFamily, Color? color}) =>
      TextStyle(fontWeight: FontWeight.normal, fontSize: 16.sp, color:
          color ?? (ThemeService().isDarkMode() ? Colors.white : Colors.black));

  TextStyle f16SemiBold({String? fontFamily, Color? color}) =>
      TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600, color:
          color ?? (ThemeService().isDarkMode() ? Colors.white : Colors.black));

  TextStyle f16Bold({String? fontFamily, Color? color}) =>
      TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold, color:
          color ?? (ThemeService().isDarkMode() ? Colors.white : Colors.black));

  TextStyle f18Regular({String? fontFamily, Color? color}) =>
      TextStyle(fontWeight: FontWeight.normal, fontSize: 18.sp, color:
          color ?? (ThemeService().isDarkMode() ? Colors.white : Colors.black));

  TextStyle f18SemiBold({String? fontFamily, Color? color}) =>
      TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600, color:
          color ?? (ThemeService().isDarkMode() ? Colors.white : Colors.black));

  TextStyle f18Bold({String? fontFamily, Color? color}) =>
      TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold, color:
          color ?? (ThemeService().isDarkMode() ? Colors.white : Colors.black));

  TextStyle f20Regular({String? fontFamily, Color? color}) =>
      TextStyle(fontWeight: FontWeight.normal, fontSize: 20.sp, color:
          color ?? (ThemeService().isDarkMode() ? Colors.white : Colors.black));

  TextStyle f20SemiBold({String? fontFamily, Color? color}) =>
      TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w600, color:
          color ?? (ThemeService().isDarkMode() ? Colors.white : Colors.black));

  TextStyle f20Bold({String? fontFamily, Color? color}) =>
      TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold, color:
          color ?? (ThemeService().isDarkMode() ? Colors.white : Colors.black));

  TextStyle f22Regular({String? fontFamily, Color? color}) =>
      TextStyle(fontWeight: FontWeight.normal, fontSize: 22.sp, color:
          color ?? (ThemeService().isDarkMode() ? Colors.white : Colors.black));

  TextStyle f22SemiBold({String? fontFamily, Color? color}) =>
      TextStyle(fontSize: 22.sp, fontWeight: FontWeight.w600, color:
          color ?? (ThemeService().isDarkMode() ? Colors.white : Colors.black));

  TextStyle f22Bold({String? fontFamily, Color? color}) =>
      TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold, color:
          color ?? (ThemeService().isDarkMode() ? Colors.white : Colors.black));
}
