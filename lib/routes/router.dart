// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:movie_database/models/movies_response.dart';
import 'package:movie_database/screens/home/home_binding.dart';
import 'package:movie_database/screens/login/login.dart';
import 'package:movie_database/screens/login/login_binding.dart';
import 'package:movie_database/screens/register/register.dart';
import 'package:movie_database/screens/register/register_binding.dart';
import 'package:movie_database/screens/search/search_binding.dart';
import '../screens/screens.dart';

class AppRouter {
  static const LOGIN = '/login';
  static const REGISTER = '/register';
  static const HOME = '/home';
  static const SEARCH = '/search';
  // get getPages => [
  //       GetPage(
  //           name: REGISTER,
  //           page: () => const Register(),
  //           binding: RegisterBiding()),
  //       GetPage(name: LOGIN, page: () => const Login()),
  //       GetPage(name: HOME, page: () => Home(), binding: HomeBinding())
  //     ];

  Route? generateRoutes(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case LOGIN:
        return GetPageRoute(
          routeName: LOGIN,
          page: () => const Login(),
          binding: LoginBinding()
        );
      case REGISTER:
        return GetPageRoute(
            routeName: REGISTER,
            page: () => const Register(),
            binding: RegisterBiding());
      case HOME:
        return GetPageRoute(
            routeName: HOME, page: () => Home(), binding: HomeBinding());
      case SEARCH:
        return GetPageRoute(
            routeName: SEARCH,
            page: () => SearchScreen(args as List<Results>),
            transition: Transition.circularReveal,
            binding: SearchBinding());
    }
  }
}
