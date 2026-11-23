import 'package:dio/dio.dart';
import 'package:ecommerce/core/utils/cache.dart';

/// Attaches the session token to endpoints marked with
/// `@Extras({AuthInterceptor.authTypeKey: AuthInterceptor.tokenAuth})`.
/// Public endpoints carry no extra and are left untouched.
class AuthInterceptor extends Interceptor {
  static const String authTypeKey = 'authType';
  static const String tokenAuth = 'token';

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (options.extra[authTypeKey] == tokenAuth) {
      final token = SharedPreferencesUtils.readData(key: CacheKeys.token);
      if (token is String && token.isNotEmpty) {
        // The backend expects a raw `token` header, not `Authorization`.
        options.headers['token'] = token;
      }
    }
    handler.next(options);
  }
}
