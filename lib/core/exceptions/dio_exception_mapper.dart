import 'package:dio/dio.dart';
import 'package:ecommerce/core/exceptions/app_exceptions.dart';

extension DioExceptionMapper on DioException {
  /// Unwraps the [AppExceptions] produced by `DioInterceptor`.
  AppExceptions toAppException() {
    final err = error;
    if (err is AppExceptions) return err;
    return UnknownException(message: 'Something went wrong');
  }
}
