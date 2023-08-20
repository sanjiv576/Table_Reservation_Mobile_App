import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../config/constants/api_endpoints.dart';
import 'dio_error_interceptor.dart';

final httpServicesProvider = Provider<Dio>((ref) => HttpServices(Dio()).dio);

class HttpServices {
  // for calling HTTP requests like POST, GET
  final Dio _dio;

// getter method
  Dio get dio => _dio;

  HttpServices(this._dio) {
    _dio
      ..options.baseUrl = ApiEndpoints.baseUrl
      ..options.connectTimeout = ApiEndpoints.connectionTimeout
      ..options.receiveTimeout = ApiEndpoints.receiveTimeout
      // DioErrorInterceptor ==> is used to handle the server errors
      ..interceptors.add(DioErrorInterceptor())
      // this PrettyDioLogger prints the response that come from API.
      // Note: do only for development environment or deployment
      // we handle this using if else statement
      ..interceptors.add(PrettyDioLogger(
          requestHeader: true, requestBody: true, responseHeader: true))
      ..options.headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      };
  }
}
