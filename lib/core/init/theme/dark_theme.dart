import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../constants/app/styles.dart';

final darkTheme = ThemeData.dark().copyWith(
    useMaterial3: true,
    scaffoldBackgroundColor: Colors.black,
    primaryColor: Styles.colors.primaryColorDark,
    cardTheme: CardTheme(color: Styles.colors.backgroundGrey),
    appBarTheme: AppBarTheme(
        backgroundColor: Styles.colors.primaryColorDark,
        systemOverlayStyle: SystemUiOverlayStyle.light),
    dividerColor: Styles.colors.white,
    textTheme: const TextTheme(
        displayLarge: TextStyle(color: Colors.white),
        displayMedium: TextStyle(color: Colors.white),
        displaySmall: TextStyle(color: Colors.white),
        headlineMedium: TextStyle(color: Colors.white),
        headlineSmall: TextStyle(color: Colors.white),
        titleLarge: TextStyle(color: Colors.white)));
