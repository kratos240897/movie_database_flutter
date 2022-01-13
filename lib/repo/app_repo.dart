// ignore_for_file: avoid_print

import 'package:movie_database/helpers/end_points.dart';
import 'package:movie_database/models/movies_response.dart';
import 'package:movie_database/service/api_service.dart';
import 'package:get/get.dart';

abstract class AppRepo {
  Future<List<Results>> getMovies(Map<String, dynamic> query);
}

class AppRepository extends AppRepo {
  final ApiService _apiService = Get.put(ApiService());
  @override
  Future<List<Results>> getMovies(Map<String, dynamic> query) async {
    try {
      final res = await _apiService.getRequest(EndPoints.discover, query);
      final movies = MoviesResponse.fromJson(res.body).results;
      return movies;
    } catch (e) {
      print(e);
      return Future.error(e);
    }
  }
}
