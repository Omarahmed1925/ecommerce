import 'package:dio/dio.dart';
import 'package:ecommerce/core/exceptions/app_exceptions.dart';

class DioInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    AppExceptions appExceptions;
    final responseData = err.response?.data;
    String message = "Something went wrong";
    if (responseData is Map) {
      final errors = responseData['errors'];
      message =
          (errors is Map ? errors['msg'] as String? : null) ??
          (responseData['message'] as String?) ??
          message;
    }
    if (err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.connectionError) {
      appExceptions = NetworkException(message: 'No Internet Connection');
    } else if (err.response?.statusCode != null) {
      appExceptions = ServerException(
        message: message,
        statusCode: err.response!.statusCode!,
      );
    } else {
      appExceptions = UnknownException(message: message);
    }
    handler.reject(
      DioException(
        requestOptions: err.requestOptions,
        response: err.response,
        error: appExceptions,
      ),
    );
  }
}
