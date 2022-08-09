// ignore_for_file: avoid_print

import 'package:movie_database/helpers/end_points.dart';
import 'package:movie_database/service/api_service.dart';
import 'package:get/get.dart';

import '../data/models/credits_response.dart';
import '../data/models/movies_response.dart';
import '../data/models/profile_response.dart';
import '../data/models/review_response.dart';
import '../data/models/video_details_response.dart';

abstract class AppRepo {
  Future<List<Results>> getMovies(String url, Map<String, dynamic> query);
  Future<List<Results>> searchMovies(Map<String, dynamic> query);
  Future<List<ReviewResults>> getMovieReviews(String id);
  Future<List<VideoResults>> getVideoDetails(String id);
  Future<List<Cast>> getCredits(String id);
  Future<ProfileResponse> getPerson(String id);
  void init();
}

class AppRepository extends AppRepo {
  final ApiService _apiService = Get.put(ApiService());
  @override
  void init() {
    _apiService.addInterceptor();
  }

  @override
  Future<List<Results>> getMovies(
      String url, Map<String, dynamic> query) async {
    try {
      final res = await _apiService.getRequest(url, query);
      final movies = MoviesResponse.fromJson(res.data).results;
      print('getMovies called>>>');
      return movies;
    } catch (e) {
      print(e);
      return Future.error(e);
    }
  }

  @override
  Future<List<Results>> searchMovies(Map<String, dynamic> query) async {
    try {
      final res = await _apiService.getRequest(EndPoints.search, query);
      final movies = MoviesResponse.fromJson(res.data).results;
      return movies;
    } catch (e) {
      print(e);
      return Future.error(e);
    }
  }

  @override
  Future<List<ReviewResults>> getMovieReviews(String id) async {
    try {
      final res = await _apiService
          .getRequest(EndPoints.reviews.replaceAll('{movie_id}', id), {});
      final reviews = ReviewResponse.fromJson(res.data).results;
      return reviews;
    } catch (e) {
      print(e);
      return Future.error(e);
    }
  }

  @override
  Future<List<VideoResults>> getVideoDetails(String id) async {
    try {
      final res = await _apiService
          .getRequest(EndPoints.videos.replaceAll('{movie_id}', id), {});
      final videos = VideoDetailsResponse.fromJson(res.data).results;
      return videos;
    } catch (e) {
      print(e);
      return Future.error(e);
    }
  }

  @override
  Future<List<Cast>> getCredits(String id) async {
    try {
      final res = await _apiService
          .getRequest(EndPoints.credits.replaceAll('{movie_id}', id), {});
      final cast = CreditsResponse.fromJson(res.data).cast;
      return cast;
    } catch (e) {
      print(e);
      return Future.error(e);
    }
  }

  @override
  Future<ProfileResponse> getPerson(String id) async {
    try {
      final res = await _apiService
          .getRequest(EndPoints.person.replaceAll('{person_id}', id), {});
      final profile = ProfileResponse.fromJson(res.data);
      return profile;
    } catch (e) {
      print(e);
      return Future.error(e);
    }
  }
}
