import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../constants/app/styles.dart';

final lightTheme = ThemeData.light().copyWith(
    useMaterial3: true,
    primaryColor: Styles.colors.primaryColor,
    appBarTheme: AppBarTheme(
        backgroundColor: Styles.colors.primaryColor,
        systemOverlayStyle: SystemUiOverlayStyle.dark),
    cardTheme: CardTheme(color: Styles.colors.white),
    dividerColor: Colors.grey,
    textTheme: const TextTheme(
        displayLarge: TextStyle(color: Colors.black),
        displayMedium: TextStyle(color: Colors.black),
        displaySmall: TextStyle(color: Colors.black),
        headlineMedium: TextStyle(color: Colors.black),
        headlineSmall: TextStyle(color: Colors.black),
        titleLarge: TextStyle(color: Colors.black)));
