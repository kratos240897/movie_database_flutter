import 'package:dartz/dartz.dart';
import '../../../../core/base/failure.dart';
import '../../../../core/base/service_locator.dart';
import '../../../../core/data/cache/cache_service.dart';
import '../models/movies_response.dart';

abstract class HomeMovieLocalDataSource {
  Future<Either<Failure, List<Results>>> getMoviesFromCache(String key);
  Future<Either<Failure, void>> putMoviesToCache(
      String key, List<Results> value);
}

class HomeMovieLocalDataSourceImpl extends HomeMovieLocalDataSource {
  @override
  Future<Either<Failure, List<Results>>> getMoviesFromCache(String key) async {
    try {
      final movies = await serviceLocator<CacheService>().homeCache.get(key);
      if (movies != null) {
        return Right(movies);
      }
      return const Left(
          LocalDatabaseQueryFailure(message: 'Unable to query from cache'));
    } catch (e) {
      return const Left(
        ParsingFailure(
          message: 'Parsing failure occured',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, void>> putMoviesToCache(
      String key, List<Results> value) async {
    try {
      serviceLocator<CacheService>().homeCache.set(key, value);
      return const Right(null);
    } catch (e) {
      return const Left(
          LocalDatabaseQueryFailure(message: 'Unable to store in cache'));
    }
  }
}
