import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_loggy_dio/flutter_loggy_dio.dart';
import '../constants/app/app_constants.dart';

class ApiService {
  var dio = Dio(BaseOptions(
      baseUrl: AppConstants.BASE_URL,
      contentType: 'application/json',
      headers: {'Authorization': 'Bearer ${AppConstants.API_KEY}'}));

  ApiService() {
    addInterceptor();
  }

  void addInterceptor() {
    dio.interceptors.add(LoggyDioInterceptor());
  }

  Future<Response> getRequest(
      String endpoint, Map<String, dynamic> query) async {
    try {
      Response response;
      response = await dio.get(endpoint,
          queryParameters: query,
          );
      return response;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return Future.error(e);
    }
  }
}
