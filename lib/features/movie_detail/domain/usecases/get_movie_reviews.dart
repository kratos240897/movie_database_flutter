import 'package:dartz/dartz.dart';
import '../../../../core/base/failure.dart';
import '../../../../core/base/service_locator.dart';
import '../../data/models/review_response.dart';
import '../repository/movie_detail_repository.dart';

class GetMovieReviews {
  Future<Either<Failure, List<ReviewResults>>> getMovieReviews(String id) async {
    return serviceLocator<MovieDetailRepository>().getMovieReviews(id);
  }
}