import 'dart:io';

import 'package:dartz/dartz.dart';
import '../../../../core/base/failure.dart';
import '../../../../core/base/service_locator.dart';
import '../../../../core/constants/app/end_points.dart';
import '../../../../core/data/models/video_details_response.dart';
import '../../../../core/service/api_service.dart';
import '../models/credits_response.dart';
import '../models/profile_response.dart';
import '../models/review_response.dart';

abstract class MovieDetailRemoteDataSource {
  Future<Either<Failure, List<ReviewResults>>> getMovieReviews(String id);
  Future<Either<Failure, List<VideoResults>>> getVideoDetails(String id);
  Future<Either<Failure, List<Cast>>> getCredits(String id);
  Future<Either<Failure, ProfileResponse>> getPerson(String id);
}

class MovieDetailRemoteDataSourceImpl extends MovieDetailRemoteDataSource {
  final apiService = serviceLocator<ApiService>();
  @override
  Future<Either<Failure, List<Cast>>> getCredits(String id) async {
    try {
      final res = await apiService.getRequest(EndPoints.credits(id), {});
      if (res.statusCode == 200) {
        final cast = CreditsResponse.fromJson(res.data).cast;
        return Right(cast);
      }
      return Left(ConnectionFailure(message: res.data['message']));
    } on SocketException {
      return const Left(
          ConnectionFailure(message: 'Please check your internet connection'));
    } catch (e) {
      return const Left(
          ParsingFailure(message: 'Unable to parse the response'));
    }
  }

  @override
  Future<Either<Failure, List<ReviewResults>>> getMovieReviews(
      String id) async {
    try {
      final res = await apiService.getRequest(EndPoints.reviews(id), {});
      if (res.statusCode == 200) {
        final reviews = ReviewResponse.fromJson(res.data).results;
        return Right(reviews);
      }
      return Left(ConnectionFailure(message: res.data['message']));
    } on SocketException {
      return const Left(
          ConnectionFailure(message: 'Please check your internet connection'));
    } catch (e) {
      return const Left(
          ParsingFailure(message: 'Unable to parse the response'));
    }
  }

  @override
  Future<Either<Failure, ProfileResponse>> getPerson(String id) async {
    try {
      final res = await apiService.getRequest(EndPoints.person(id), {});
      if (res.statusCode == 200) {
        final profile = ProfileResponse.fromJson(res.data);
        return Right(profile);
      }
      return Left(ConnectionFailure(message: res.data['message']));
    } on SocketException {
      return const Left(
          ConnectionFailure(message: 'Please check your internet connection'));
    } catch (e) {
      return const Left(
          ParsingFailure(message: 'Unable to parse the response'));
    }
  }

  @override
  Future<Either<Failure, List<VideoResults>>> getVideoDetails(String id) async {
    try {
      final res = await apiService.getRequest(EndPoints.videos(id), {});
      if (res.statusCode == 200) {
        final videos = VideoDetailsResponse.fromJson(res.data).results;
        return Right(videos);
      }
      return Left(ConnectionFailure(message: res.data['message']));
    } on SocketException {
      return const Left(
          ConnectionFailure(message: 'Please check your internet connection'));
    } catch (e) {
      return const Left(
          ParsingFailure(message: 'Unable to parse the response'));
    }
  }
}
