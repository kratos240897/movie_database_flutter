import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../helpers/constants.dart';

class ThemeService {
  ThemeService._();
  static ThemeService? _instance;
  factory ThemeService() => _instance ??= ThemeService._();
  final _getStorage = GetStorage();
  final _storageKey = Constants.THEME_KEY;

  ThemeMode getThemeMode() {
    return isDarkMode() ? ThemeMode.dark : ThemeMode.light;
  }

  bool isDarkMode() {
    return _getStorage.read(_storageKey) ?? false;
  }

  void _saveThemeMode(bool isDarkMode) {
    _getStorage.write(_storageKey, isDarkMode);
  }

  Future<void> changeThemeMode() async {
    Get.changeThemeMode(isDarkMode() ? ThemeMode.light : ThemeMode.dark);
    _saveThemeMode(!isDarkMode());
  }
}
