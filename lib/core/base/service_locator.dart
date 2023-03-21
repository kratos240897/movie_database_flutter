import 'package:get_it/get_it.dart';
import '../../features/home/data/datasource/home_movie_local_source.dart';
import '../../features/home/data/datasource/home_movie_remote_source.dart';
import '../../features/home/data/repository/home_repository_impl.dart';
import '../../features/home/domain/repository/home_repository.dart';
import '../../features/home/domain/usecases/get_movies_from_cache.dart';
import '../../features/home/domain/usecases/get_movies_from_server.dart';
import '../../features/home/domain/usecases/put_movies_to_cache.dart';
import '../../features/movie_detail/data/datasource/movie_detail_remote_source.dart';
import '../../features/movie_detail/data/repository/movie_detail_repository_impl.dart';
import '../../features/movie_detail/domain/repository/movie_detail_repository.dart';
import '../../features/movie_detail/domain/usecases/get_credits.dart';
import '../../features/movie_detail/domain/usecases/get_movie_reviews.dart';
import '../../features/movie_detail/domain/usecases/get_person.dart';
import '../../features/movie_detail/domain/usecases/get_video_details.dart';
import '../data/cache/cache_service.dart';
import '../service/api_service.dart';

final serviceLocator = GetIt.instance;
Future<void> setUpServiceLocator() async {
  // services
  serviceLocator.registerSingleton<ApiService>(ApiService());
  serviceLocator.registerSingleton<CacheService>(CacheService());

  // use cases
  // HOME
  serviceLocator.registerFactory(() => GetMoviesFromServer());
  serviceLocator.registerFactory(() => GetMoviesFromCache());
  serviceLocator.registerFactory(() => PutMoviesToCache());

  // MOVIE-DETAIL
  serviceLocator.registerFactory(() => GetCredits());
  serviceLocator.registerFactory(() => GetVideoDetails());
  serviceLocator.registerFactory(() => GetMovieReviews());
  serviceLocator.registerFactory(() => GetPerson());

  // repositories
  // HOME
  serviceLocator.registerFactory<HomeRepository>(() => HomeRepositoryImpl());

  // MOVIE-DETAIL
  serviceLocator.registerFactory<MovieDetailRepository>(
      () => MovieDetailRepositoryImpl());

  // data sources
  // HOME
  serviceLocator.registerFactory<HomeMovieRemoteDataSource>(
      () => HomeMovieRemoteDataSourceImpl());
  serviceLocator.registerFactory<HomeMovieLocalDataSource>(
      () => HomeMovieLocalDataSourceImpl());

  // MOVIE-DETAIL
  serviceLocator.registerFactory<MovieDetailRemoteDataSource>(
      () => MovieDetailRemoteDataSourceImpl());
}
