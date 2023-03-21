import 'package:dartz/dartz.dart';
import '../../../../core/base/failure.dart';
import '../../data/models/movies_response.dart';

abstract class HomeRepository {
  Future<Either<Failure, List<Results>>> getMovies(
      String url, Map<String, dynamic> query);

  Future<Either<Failure, List<Results>>> getMoviesFromCache(String key);

  Future<Either<Failure, void>> putMoviesToCache(String key, List<Results> value);
}
