import 'package:dartz/dartz.dart';
import '../../../../core/base/failure.dart';
import '../../../../core/base/service_locator.dart';
import '../../data/models/movies_response.dart';
import '../repository/home_repository.dart';

class PutMoviesToCache {
  Future<Either<Failure, void>> putMoviesToCache(
      String key, List<Results> value) {
    return serviceLocator<HomeRepository>().putMoviesToCache(key, value);
  }
}
