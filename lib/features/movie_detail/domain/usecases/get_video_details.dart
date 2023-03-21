import 'package:dartz/dartz.dart';
import '../../../../core/base/failure.dart';
import '../../../../core/base/service_locator.dart';
import '../../../../core/data/models/video_details_response.dart';
import '../repository/movie_detail_repository.dart';

class GetVideoDetails {
  Future<Either<Failure, List<VideoResults>>> getVideoDetails(String id) async {
    return serviceLocator<MovieDetailRepository>().getVideoDetails(id);
  }
}