// lib/core/network/interceptors/error_interceptor.dart

import 'package:dio/dio.dart';

class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Map Dio connection errors to readable messages
    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        throw DioException(
          requestOptions: err.requestOptions,
          error: 'Connection timed out. Check your internet.',
          type: err.type,
        );
      case DioExceptionType.connectionError:
        throw DioException(
          requestOptions: err.requestOptions,
          error: 'No internet connection.',
          type: err.type,
        );
      default:
        handler.next(err);
    }
  }
}