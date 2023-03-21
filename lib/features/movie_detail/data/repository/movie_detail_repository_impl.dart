import 'package:dartz/dartz.dart';
import '../../../../core/base/failure.dart';
import '../../../../core/base/service_locator.dart';
import '../../domain/repository/movie_detail_repository.dart';
import '../datasource/movie_detail_remote_source.dart';
import '../models/credits_response.dart';
import '../models/profile_response.dart';
import '../models/review_response.dart';
import '../../../../core/data/models/video_details_response.dart';

class MovieDetailRepositoryImpl extends MovieDetailRepository {
  @override
  Future<Either<Failure, List<ReviewResults>>> getMovieReviews(
      String id) async {
    return serviceLocator<MovieDetailRemoteDataSource>().getMovieReviews(id);
  }

  @override
  Future<Either<Failure, List<VideoResults>>> getVideoDetails(String id) async {
    return serviceLocator<MovieDetailRemoteDataSource>().getVideoDetails(id);
  }

  @override
  Future<Either<Failure, List<Cast>>> getCredits(String id) async {
    return serviceLocator<MovieDetailRemoteDataSource>().getCredits(id);
  }

  @override
  Future<Either<Failure, ProfileResponse>> getPerson(String id) async {
    return serviceLocator<MovieDetailRemoteDataSource>().getPerson(id);
  }
}
