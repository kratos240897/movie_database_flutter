import 'package:dartz/dartz.dart';
import '../../../../core/base/failure.dart';
import '../../../../core/base/service_locator.dart';
import '../../data/models/profile_response.dart';
import '../repository/movie_detail_repository.dart';

class GetPerson {
  Future<Either<Failure, ProfileResponse>> getPerson(String id) async {
    return serviceLocator<MovieDetailRepository>().getPerson(id);
  }
}