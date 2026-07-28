// lib/core/network/dio_client.dart

import 'package:dio/dio.dart';

import '../constant/api_config.dart';
import 'auth_interceptor.dart';
import 'error_interceptor.dart';
import 'logging_interceptor.dart';

class DioClient {
  late final Dio _dio;

  DioClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConfig.baseUrl,          // e.g. 'https://api.meesa.com/'
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 40),
        sendTimeout: const Duration(seconds: 40),
        headers: {
          'Accept': 'application/json',
        },
      ),
    );

    // ── Interceptors ─────────────────────────────────────────
    _dio.interceptors.addAll([
      AuthInterceptor(),     // attaches Bearer token to every request
      LoggingInterceptor(),  // logs req/res (only in debug)
      ErrorInterceptor(),    // normalises error responses
    ]);
  }

  Dio get dio => _dio;
}