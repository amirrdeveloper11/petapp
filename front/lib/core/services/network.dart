import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../services/secure_storage_service.dart';

class AppDio {
  static final Dio dio = Dio(
    BaseOptions(
      baseUrl: 'http://10.0.2.2:8000/api',
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 5),
      headers: const {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    ),
  )..interceptors.addAll([_authInterceptor, _loggerInterceptor]);

  static final _authInterceptor = InterceptorsWrapper(
    onRequest: (options, handler) async {
      final token = await SecureStorageService.readAccessToken();
      if (token != null) {
        options.headers['Authorization'] = 'Bearer $token';
      }
      handler.next(options);
    },
  );

  static final _loggerInterceptor = InterceptorsWrapper(
    onRequest: (options, handler) {
      debugPrint("➡️ [REQUEST] ${options.method} ${options.uri}");
      debugPrint("Headers: ${options.headers}");
      debugPrint("Data: ${options.data}");
      handler.next(options);
    },
    onResponse: (response, handler) {
      debugPrint(
        "[RESPONSE] ${response.statusCode} ${response.requestOptions.uri}",
      );
      debugPrint("Data: ${response.data}");
      handler.next(response);
    },
    onError: (error, handler) {
      debugPrint("❌ [ERROR] ${error.type} ${error.requestOptions.uri}");
      if (error.response != null) {
        debugPrint("Status: ${error.response?.statusCode}");
        debugPrint("Data: ${error.response?.data}");
      }
      handler.next(error);
    },
  );
}
