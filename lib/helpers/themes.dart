import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'styles.dart';

class Themes {
  final lightTheme = ThemeData.light().copyWith(
      primaryColor: Styles.colors.primaryColor,
      appBarTheme: AppBarTheme(
          backgroundColor: Styles.colors.primaryColor,
          systemOverlayStyle: SystemUiOverlayStyle.dark),
      cardTheme: CardTheme(color: Styles.colors.white),
      dividerColor: Colors.grey,
      textTheme: const TextTheme(
          headline1: TextStyle(color: Colors.black),
          headline2: TextStyle(color: Colors.black),
          headline3: TextStyle(color: Colors.black),
          headline4: TextStyle(color: Colors.black),
          headline5: TextStyle(color: Colors.black),
          headline6: TextStyle(color: Colors.black)));
  final darkTheme = ThemeData.dark().copyWith(
      scaffoldBackgroundColor: Colors.black,
      primaryColor: Styles.colors.primaryColorDark,
      cardTheme: CardTheme(color: Styles.colors.backgroundGrey),
      appBarTheme: AppBarTheme(
          backgroundColor: Styles.colors.primaryColorDark,
          systemOverlayStyle: SystemUiOverlayStyle.light),
      dividerColor: Styles.colors.white,
      textTheme: const TextTheme(
          headline1: TextStyle(color: Colors.white),
          headline2: TextStyle(color: Colors.white),
          headline3: TextStyle(color: Colors.white),
          headline4: TextStyle(color: Colors.white),
          headline5: TextStyle(color: Colors.white),
          headline6: TextStyle(color: Colors.white)));
}
