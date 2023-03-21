import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import '../constants/app/end_points.dart';
import '../../features/home/data/models/movies_response.dart';
import '../service/api_service.dart';

class SearchRepository {
  final ApiService _apiService = Get.find<ApiService>();

  Future<List<Results>> searchMovies(Map<String, dynamic> query) async {
    try {
      final res = await _apiService.getRequest(EndPoints.search, query);
      final movies = MoviesResponse.fromJson(res.data).results;
      return movies;
    } catch (e) {
      debugPrint(e.toString());
      return Future.error(e);
    }
  }
}