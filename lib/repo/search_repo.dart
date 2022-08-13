import 'package:get/instance_manager.dart';
import '../data/models/movies_response.dart';
import '../helpers/end_points.dart';
import '../service/api_service.dart';

class SearchRepository {
  final ApiService _apiService = Get.find<ApiService>();

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
}