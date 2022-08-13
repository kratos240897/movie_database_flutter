// ignore_for_file: avoid_print

import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:flutter_loggy_dio/flutter_loggy_dio.dart';
import 'package:movie_database/helpers/constants.dart';

class ApiService {
  var dio = Dio(BaseOptions(
      baseUrl: Constants.BASE_URL,
      contentType: 'application/json',
      headers: {'Authorization': 'Bearer ${Constants.API_KEY}'}));

  void addInterceptor() {
    dio.interceptors.add(LoggyDioInterceptor());
    dio.interceptors.add(
        DioCacheManager(CacheConfig(baseUrl: Constants.BASE_URL)).interceptor);
  }

  Future<Response> getRequest(
      String endpoint, Map<String, dynamic> query) async {
    try {
      Response response;
      // Set maxState if you want to return cache in case of 500, 400 error:
      // You can force refresh too:
      response = await dio.get(endpoint,
          queryParameters: query,
          options: buildCacheOptions(const Duration(days: 7),
              maxStale: const Duration(days: 10)));
      return response;
    } catch (e) {
      print(e);
      return Future.error(e);
    }
  }
}
