// ignore_for_file: avoid_print

import 'package:dio/dio.dart';
import 'package:flutter_loggy_dio/flutter_loggy_dio.dart';
import 'package:movie_database/helpers/constants.dart';

class ApiService {
  var dio = Dio(BaseOptions(
      baseUrl: Constants.BASE_URL,
      contentType: 'application/json',
      headers: {'Authorization': 'Bearer ${Constants.API_KEY}'}));

  void addInterceptor() {
    dio.interceptors.add(LoggyDioInterceptor());
  }

  Future<Response> getRequest(
      String endpoint, Map<String, dynamic> query) async {
    try {
      Response response;
      response = await dio.get(endpoint, queryParameters: query);
      return response;
    } catch (e) {
      print(e);
      return Future.error(e);
    }
  }
}
