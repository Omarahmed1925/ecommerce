import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:ecommerce/api/api_endpts.dart';
import 'package:ecommerce/api/dio/auth_interceptor.dart';
import 'package:ecommerce/api/dio/dio_interceptor.dart';
import 'package:ecommerce/api/web_services.dart';
import 'package:injectable/injectable.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

@module
abstract class DioModule {
  @singleton
  @injectable
  BaseOptions provideBaseOptions() {
    return BaseOptions(
      baseUrl: ApiEndPts.baseUrl,
      connectTimeout: Duration(seconds: 20),
      receiveTimeout: Duration(seconds: 20),
    );
  }

  @singleton
  @injectable
  PrettyDioLogger providePrettyDioLogger() {
    return PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      responseBody: true,
      responseHeader: false,
      error: true,
      compact: true,
      maxWidth: 90,
    );
  }

  @singleton
  @injectable
  WebServices provideWebServices(Dio dio) => WebServices(dio);
  @singleton
  @injectable
  Dio provideDio(BaseOptions baseOptions, PrettyDioLogger logger) {
    Dio dio = Dio(baseOptions);
    dio.interceptors.add(AuthInterceptor());
    dio.interceptors.add(DioInterceptor());
    // Logs headers (incl. the session token), so keep it out of release.
    if (kDebugMode) dio.interceptors.add(logger);
    return dio;
  }
}
