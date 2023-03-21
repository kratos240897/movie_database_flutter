import 'package:dartz/dartz.dart';
import '../../../../core/base/failure.dart';
import '../../../../core/data/models/video_details_response.dart';
import '../../data/models/credits_response.dart';
import '../../data/models/profile_response.dart';
import '../../data/models/review_response.dart';

abstract class MovieDetailRepository {
  Future<Either<Failure, List<ReviewResults>>> getMovieReviews(String id);
  Future<Either<Failure, List<VideoResults>>> getVideoDetails(String id);
  Future<Either<Failure, List<Cast>>> getCredits(String id);
  Future<Either<Failure, ProfileResponse>> getPerson(String id);
}
