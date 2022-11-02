// ignore_for_file: avoid_print
import 'package:get/get.dart';
import '../data/models/movies_response.dart';
import '../service/api_service.dart';

class HomeRepository {
  final ApiService _apiService = Get.find<ApiService>();

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
}
