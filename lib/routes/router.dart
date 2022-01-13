// ignore_for_file: constant_identifier_names

import 'package:get/route_manager.dart';
import 'package:movie_database/screens/home/home_binding.dart';
import '../screens/screens.dart';

class AppRouter {
  static const HOME = '/';
  static const SEARCH = '/search';
  get getPages =>
      [GetPage(name: HOME, page: () => Home(), binding: HomeBinding())];
}
