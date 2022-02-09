// ignore_for_file: constant_identifier_names

import 'package:get/route_manager.dart';
import 'package:movie_database/screens/home/home_binding.dart';
import 'package:movie_database/screens/login/login.dart';
import 'package:movie_database/screens/register/register.dart';
import 'package:movie_database/screens/register/register_binding.dart';
import '../screens/screens.dart';

class AppRouter {
  static const LOGIN = '/login';
  static const REGISTER = '/register';
  static const HOME = '/';
  static const SEARCH = '/search';
  get getPages => [
        GetPage(
            name: REGISTER,
            page: () => const Register(),
            binding: RegisterBiding()),
        GetPage(name: LOGIN, page: () => const Login()),
        GetPage(name: HOME, page: () => Home(), binding: HomeBinding())
      ];
}
