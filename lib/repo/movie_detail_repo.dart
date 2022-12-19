import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import '../data/models/credits_response.dart';
import '../data/models/profile_response.dart';
import '../data/models/review_response.dart';
import '../data/models/video_details_response.dart';
import '../helpers/end_points.dart';
import '../service/api_service.dart';

class MovieDetailRepository {
  final ApiService _apiService = Get.find<ApiService>();

  Future<List<ReviewResults>> getMovieReviews(String id) async {
    try {
      final res = await _apiService.getRequest(EndPoints.reviews(id), {});
      final reviews = ReviewResponse.fromJson(res.data).results;
      return reviews;
    } catch (e) {
      debugPrint(e.toString());
      return Future.error(e);
    }
  }

  Future<List<VideoResults>> getVideoDetails(String id) async {
    try {
      final res = await _apiService.getRequest(EndPoints.videos(id), {});
      final videos = VideoDetailsResponse.fromJson(res.data).results;
      return videos;
    } catch (e) {
      debugPrint(e.toString());
      return Future.error(e);
    }
  }

  Future<List<Cast>> getCredits(String id) async {
    try {
      final res = await _apiService.getRequest(EndPoints.credits(id), {});
      final cast = CreditsResponse.fromJson(res.data).cast;
      return cast;
    } catch (e) {
      debugPrint(e.toString());
      return Future.error(e);
    }
  }

  Future<ProfileResponse> getPerson(String id) async {
    try {
      final res = await _apiService.getRequest(EndPoints.person(id), {});
      final profile = ProfileResponse.fromJson(res.data);
      return profile;
    } catch (e) {
      debugPrint(e.toString());
      return Future.error(e);
    }
  }
}
