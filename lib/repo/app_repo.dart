// ignore_for_file: avoid_print

import 'package:movie_database/helpers/end_points.dart';
import 'package:movie_database/models/movies_response.dart';
import 'package:movie_database/models/review_response.dart';
import 'package:movie_database/service/api_service.dart';
import 'package:get/get.dart';

abstract class AppRepo {
  Future<List<Results>> getMovies(String url, Map<String, dynamic> query);
  Future<List<Results>> searchMovies(Map<String, dynamic> query);
  Future<List<ReviewResults>> getMovieReviews(String id);
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
}
