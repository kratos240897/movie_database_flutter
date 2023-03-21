import 'package:dartz/dartz.dart';
import '../../../../core/base/failure.dart';
import '../../../../core/base/service_locator.dart';
import '../../data/models/credits_response.dart';
import '../repository/movie_detail_repository.dart';

class GetCredits {
  Future<Either<Failure, List<Cast>>> getCredits(String id) async {
    return serviceLocator<MovieDetailRepository>().getCredits(id);
  }
}
