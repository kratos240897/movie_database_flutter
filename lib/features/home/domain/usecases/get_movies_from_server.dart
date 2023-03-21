import 'package:dartz/dartz.dart';
import '../../../../core/base/failure.dart';
import '../../../../core/base/service_locator.dart';
import '../../data/models/movies_response.dart';
import '../repository/home_repository.dart';

class GetMoviesFromServer {
  Future<Either<Failure, List<Results>>> getMoviesFromServer(
      String url, Map<String, dynamic> query) {
    return serviceLocator<HomeRepository>().getMovies(url, query);
  }
}
