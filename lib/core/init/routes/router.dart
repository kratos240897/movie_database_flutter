// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import '../../../features/favorites/favorites.dart';
import '../../../features/favorites/favorties_binding.dart';
import '../../../features/home/presentation/views/home.dart';
import '../../../features/home/presentation/home_binding.dart';
import '../../../features/login/login.dart';
import '../../../features/login/login_binding.dart';
import '../../../features/movie_detail/presentation/movie_detail_binding.dart';
import '../../../features/movie_detail/presentation/views/movie_detail_screen.dart';
import '../../../features/person/person.dart';
import '../../../features/person/person_binding.dart';
import '../../../features/register/register.dart';
import '../../../features/register/register_binding.dart';
import '../../../features/reviews/reviews.dart';
import '../../../features/reviews/reviews_binding.dart';
import '../../../features/search/search_binding.dart';
import '../../../features/search/search_screen.dart';
import '../../../features/video/video.dart';
import '../../../features/video/video_binding.dart';
import '../../../features/movie_detail/data/models/review_response.dart';
import '../../../features/home/data/models/movies_response.dart';

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
            routeName: HOME, page: () => HomeV2(), binding: HomeBinding());
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
          binding: MovieDetailBinding(),
        );
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
