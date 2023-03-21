// ignore_for_file: avoid_print
import 'package:dartz/dartz.dart';
import '../../../../core/base/failure.dart';
import '../../../../core/base/service_locator.dart';
import '../../domain/repository/home_repository.dart';
import '../datasource/home_movie_local_source.dart';
import '../datasource/home_movie_remote_source.dart';
import '../models/movies_response.dart';

class HomeRepositoryImpl extends HomeRepository {
  @override
  Future<Either<Failure, List<Results>>> getMovies(
      String url, Map<String, dynamic> query) {
    return serviceLocator<HomeMovieRemoteDataSource>()
        .getMoviesFromServer(url, query);
  }

  @override
  Future<Either<Failure, List<Results>>> getMoviesFromCache(String key) {
    return serviceLocator<HomeMovieLocalDataSource>().getMoviesFromCache(key);
  }

  @override
  Future<Either<Failure, void>> putMoviesToCache(
      String key, List<Results> value) {
    return serviceLocator<HomeMovieLocalDataSource>()
        .putMoviesToCache(key, value);
  }
}
