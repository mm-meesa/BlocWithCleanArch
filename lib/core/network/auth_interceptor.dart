// lib/core/network/interceptors/auth_interceptor.dart

import 'package:dio/dio.dart';

import '../../services/auth_service.dart';
import '../constant/api_config.dart';

class AuthInterceptor extends Interceptor {
  @override
  void onRequest(
      RequestOptions options,
      RequestInterceptorHandler handler,
      ) async {

   /* // Skip auth header for public endpoints (register, login, OTP, etc.)
    final publicPaths = [
      ApiConfig.loginEndpoint,
    ];

    final isPublic = publicPaths.any(
          (path) => options.path.contains(path),
    );

    if (!isPublic) {
      final token = await AuthService.getAccessToken(); // read from storage
      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    }*/

    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // Token expired → refresh and retry once
    if (err.response?.statusCode == 401) {
      final refreshed = await _tryRefreshToken();
      if (refreshed) {
        // Retry the original request with new token
        final token = await AuthService.getAccessToken(); // read from storage
        err.requestOptions.headers['Authorization'] = 'Bearer $token';
        final retryResponse = await Dio().fetch(err.requestOptions);
        return handler.resolve(retryResponse);
      }
    }
    handler.next(err);
  }

  Future<bool> _tryRefreshToken() async {
    // call your refresh endpoint here
    // return true if success, false otherwise
    return false;
  }
}