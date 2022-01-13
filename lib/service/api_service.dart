// ignore_for_file: avoid_print

import 'package:get/get_connect.dart';
import 'package:get/get_connect/http/src/request/request.dart';
import 'package:movie_database/helpers/constants.dart';

class ApiService extends GetConnect {
  @override
  void onInit() {
    httpClient.baseUrl = Constants.BASE_URL;
    httpClient.defaultContentType = 'application/json';
    httpClient.timeout = const Duration(seconds: 10);
    var headers = {'Authorization': 'Bearer ${Constants.API_KEY}'};

    httpClient.addAuthenticator((Request request) async {
      request.headers.addAll(headers);
      return request;
    });

    httpClient.addRequestModifier((Request request) async {
      print('METHOD ${request.method}');
      return request;
    });

    httpClient.addResponseModifier((request, response) async {
      print('RESPONSE ${response.body}');
      return response;
    });
    super.onInit();
  }

  Future<Response> getRequest(String url, Map<String, dynamic> query) =>
      get(url, query: query);
}
