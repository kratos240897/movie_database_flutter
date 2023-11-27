import 'package:evolvex_lib/evolvex_lib.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:movie_database/features/home/data/models/movies_response.dart';

import '../../../core/base/service_locator.dart';
import '../../../core/constants/app/end_points.dart';
import '../../../core/constants/enums/snackbar_status.dart';
import '../../../core/init/local_storage/boxes.dart';
import '../../../core/service/theme_service.dart';
import '../../../core/init/utils/utils.dart' as localUtils;
import '../domain/usecases/get_movies_from_server.dart';

abstract class HomeState extends BaseState {}

class HomeLoadingState extends HomeState {}

class HomeErrorState extends HomeState {
  final String errorMessage;

  HomeErrorState(this.errorMessage);
}

class HomeBloc extends BaseCubit<HomeState> {
  HomeBloc() : super(initialState: HomeLoadingState());

  final utils = localUtils.Utils();
  int favoritesCount = 0;
  bool isDarkMode = false;
  final List<List<Results>> allMoviesList = List.empty();
  final List<Results> nowPlaying = List.empty();
  final List<Results> newMovies = List.empty();
  final List<Results> topRated = List.empty();
  final List<Results> upcoming = List.empty();
  final List<Results> tvShows = List.empty();
  late String _startDate;
  late String _endDate;

  init() {
    isDarkMode = ThemeService().getThemeMode() == ThemeMode.dark;
    favoritesCount = Boxes.getFavorites().length;
    _startDate = DateFormat('yyyy-MM-dd')
        .format(DateTime.now().subtract(const Duration(days: 30)));
    _endDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
  }

  Future<void> changeTheme() async {
    ThemeService().changeThemeMode().then((_) {
      isDarkMode = ThemeService().getThemeMode() == ThemeMode.dark;
      utils.showSnackBar(
          'Theme',
          isDarkMode ? 'Switched to Dark Mode' : 'Switched to Light Mode',
          SnackBarStatus.info);
    });
  }

  Future<void> getAllMovies() async {
    await Future.wait([
      fetchMovies(EndPoints.trending, {}, nowPlaying),
      fetchMovies(
          EndPoints.discover,
          {
            'primary_release_date.gte': _startDate,
            'primary_release_date.lte': _endDate
          },
          newMovies),
      fetchMovies(EndPoints.topRated, {}, topRated),
      fetchMovies(EndPoints.upcoming, {}, upcoming),
      fetchMovies(EndPoints.tvShows, {}, tvShows)
    ]);
  }

  Future<void> fetchMovies(
      String url, Map<String, dynamic> query, List<Results> movielist) async {
    final result = await serviceLocator<GetMoviesFromServer>()
        .getMoviesFromServer(url, query);
    result.fold((failure) {
      utils.showSnackBar('Failure', failure.message, SnackBarStatus.failure);
    }, (data) {
      movielist.clear();
      movielist.addAll(data);
      allMoviesList.add(data);
    });
  }

  @override
  HomeState getErrorState(Object error) {
    if (error is Failure) {
      return HomeErrorState(error.message);
    }
    return HomeErrorState('An error occured: $error');
  }
}
