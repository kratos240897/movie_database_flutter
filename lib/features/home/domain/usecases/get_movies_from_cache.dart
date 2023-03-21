import 'package:dartz/dartz.dart';
import '../../../../core/base/failure.dart';
import '../../../../core/base/service_locator.dart';
import '../../data/models/movies_response.dart';
import '../repository/home_repository.dart';

class GetMoviesFromCache {
  Future<Either<Failure, List<Results>>> getMoviesFromCache(String key) {
    return serviceLocator<HomeRepository>().getMoviesFromCache(key);
  }
}
