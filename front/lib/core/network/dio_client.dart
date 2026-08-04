import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:front/core/secure_storage_service.dart';

import 'api_config.dart';

class DioClient {
  DioClient._();

  static final Dio instance = _create();

  static Dio _create() {
    final dio = Dio(
      BaseOptions(
        baseUrl: ApiConfig.apiBaseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
        receiveDataWhenStatusError: true,
        headers: const {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await SecureStorageService.readAccessToken();
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
      ),
    );

    if (kDebugMode) {
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            debugPrint('[REQUEST] ${options.method} ${options.uri}');
            debugPrint('Headers: ${options.headers}');
            debugPrint('Data: ${options.data}');
            handler.next(options);
          },
          onResponse: (response, handler) {
            debugPrint(
              '[RESPONSE] ${response.statusCode} ${response.requestOptions.uri}',
            );
            debugPrint('Data: ${response.data}');
            handler.next(response);
          },
          onError: (error, handler) {
            debugPrint(
              '[ERROR] ${error.response?.statusCode} ${error.requestOptions.uri}',
            );
            debugPrint('Message: ${error.message}');
            if (error.response != null) {
              debugPrint('Response data: ${error.response?.data}');
            }
            handler.next(error);
          },
        ),
      );
    }

    return dio;
  }
}