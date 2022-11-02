// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import '../data/models/movies_response.dart';
import '../data/models/review_response.dart';
import '../screens/favorites/favorites.dart';
import '../screens/favorites/favorties_binding.dart';
import '../screens/home/home.dart';
import '../screens/home/home_binding.dart';
import '../screens/login/login.dart';
import '../screens/login/login_binding.dart';
import '../screens/movie_detail/movie_detail_binding.dart';
import '../screens/movie_detail/movie_detail_screen.dart';
import '../screens/person/person.dart';
import '../screens/person/person_binding.dart';
import '../screens/register/register.dart';
import '../screens/register/register_binding.dart';
import '../screens/reviews/reviews.dart';
import '../screens/reviews/reviews_binding.dart';
import '../screens/search/search_binding.dart';
import '../screens/search/search_screen.dart';
import '../screens/video/video.dart';
import '../screens/video/video_binding.dart';

class PageRouter {
  PageRouter._();
  static PageRouter? instance;
  factory PageRouter() {
    if (instance != null) {
      return instance!;
    }
    return PageRouter._();
  }
  static const LOGIN = '/login';
  static const REGISTER = '/register';
  static const HOME = '/home';
  static const SEARCH = '/search';
  static const MOVIE_DETAIL = '/movie-detail';
  static const REVIEWS = '/reviews';
  static const VIDEO = '/video';
  static const PERSON = '/person';
  static const FAVORITES = '/favorites';

  Route? generateRoutes(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case LOGIN:
        return GetPageRoute(
            routeName: LOGIN,
            page: () => const Login(),
            binding: LoginBinding());
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
            transition: Transition.downToUp,
            binding: SearchBinding());
      case MOVIE_DETAIL:
        return GetPageRoute(
            routeName: MOVIE_DETAIL,
            page: () => MovieDetailScreen(movie: args as Results),
            transition: Transition.downToUp,
            binding: MovieDetailBinding());
      case REVIEWS:
        return GetPageRoute(
            routeName: REVIEWS,
            page: () => Review(reviews: args as List<ReviewResults>),
            transition: Transition.downToUp,
            binding: ReviewsBinding());
      case VIDEO:
        return GetPageRoute(
            routeName: VIDEO,
            page: () => Video(videoId: args as List<String>),
            transition: Transition.zoom,
            binding: VideoBindings());
      case PERSON:
        final title = (args as Map)['title'];
        final id = args['id'];
        return GetPageRoute(
            routeName: PERSON,
            page: () => Person(title: title, id: id),
            binding: PersonBinding(),
            transition: Transition.circularReveal);
      case FAVORITES:
        return GetPageRoute(
            routeName: PageRouter.FAVORITES,
            page: () => const Favorties(),
            transition: Transition.rightToLeftWithFade,
            binding: FavoritesBinding());
    }
    return null;
  }
}
