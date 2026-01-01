import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:front/core/services/secure_storage_service.dart';
import 'package:front/features/auth/user/model/user_model.dart';

class AuthServiceDio {
  AuthServiceDio._();

  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'http://10.0.2.2:8000/api',
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 5),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    ),
  )..interceptors.add(_logger);

  static final _logger = InterceptorsWrapper(
    onRequest: (o, h) {
      debugPrint("➡️ ${o.method} ${o.uri}");
      h.next(o);
    },
    onResponse: (r, h) {
      debugPrint("✅ ${r.statusCode} ${r.requestOptions.uri}");
      h.next(r);
    },
    onError: (e, h) {
      debugPrint("❌ ${e.type} ${e.requestOptions.uri}");
      h.next(e);
    },
  );

  // PUBLIC API

  static Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
  }) {
    return _post('/auth/register', {
      'name': name,
      'email': email,
      'password': password,
      'password_confirmation': passwordConfirmation,
    }, saveAuth: true);
  }

  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) {
    return _post('/auth/login', {
      'email': email,
      'password': password,
    }, saveAuth: true);
  }

  static Future<Map<String, dynamic>> refreshToken({
    required String refreshToken,
  }) {
    return _post('/auth/refresh', {
      'refresh_token': refreshToken,
    }, saveAuth: true);
  }

  static Future<Map<String, dynamic>> updateProfile({
    required String name,
    required String email,
    String? password,
  }) async {
    final token = await SecureStorageService.readAccessToken();
    return _post(
      '/auth/update-profile',
      {
        'name': name,
        'email': email,
        if (password?.isNotEmpty == true) 'password': password,
      },
      token: token,
      saveUserOnly: true,
    );
  }

  static Future<Map<String, dynamic>> deleteAccount() async {
    final token = await SecureStorageService.readAccessToken();
    final res = await _delete('/auth/delete-account', token: token);
    await SecureStorageService.deleteAll();
    return res;
  }

  static Future<void> logout() async {
    try {
      final token = await SecureStorageService.readAccessToken();
      if (token != null) {
        await _post('/auth/logout', {}, token: token);
      }
    } catch (_) {}
    await SecureStorageService.deleteAll();
  }

  static Future<UserModel?> readStoredUser() async {
    final jsonStr = await SecureStorageService.readUserJson();
    if (jsonStr == null) return null;
    return UserModel.fromJson(jsonDecode(jsonStr));
  }

  // CORE REQUEST LAYER
  static Future<Map<String, dynamic>> _post(
    String path,
    Map<String, dynamic> data, {
    String? token,
    bool saveAuth = false,
    bool saveUserOnly = false,
  }) async {
    try {
      final response = await _dio.post(
        path,
        data: data,
        options: token == null
            ? null
            : Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (saveAuth) {
        await _saveAuth(response.data);
      } else if (saveUserOnly) {
        await _saveUser(response.data);
      }

      return _ok(response);
    } on DioException catch (e) {
      return _fail(e);
    }
  }

  static Future<Map<String, dynamic>> _delete(
    String path, {
    String? token,
  }) async {
    try {
      final response = await _dio.delete(
        path,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      return _ok(response);
    } on DioException catch (e) {
      return _fail(e);
    }
  }

  // HELPERS

  static Future<void> _saveAuth(Map<String, dynamic> json) async {
    final data = json['data'];
    if (data == null) return;

    if (data['access_token'] != null) {
      await SecureStorageService.writeAccessToken(data['access_token']);
    }
    if (data['refresh_token'] != null) {
      await SecureStorageService.writeRefreshToken(data['refresh_token']);
    }
    if (data['user'] != null) {
      await SecureStorageService.writeUserJson(jsonEncode(data['user']));
    }
  }

  static Future<void> _saveUser(Map<String, dynamic> json) async {
    final user = json['data']?['user'];
    if (user != null) {
      await SecureStorageService.writeUserJson(jsonEncode(user));
    }
  }

  static Map<String, dynamic> _ok(Response r) => {
    'statusCode': r.statusCode,
    'body': r.data,
  };

  static Map<String, dynamic> _fail(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.connectionError) {
      return {
        'statusCode': 0,
        'body': {'message': 'Server unavailable'},
      };
    }

    final data = e.response?.data;
    return {
      'statusCode': e.response?.statusCode ?? 500,
      'body': {'message': data?['message'] ?? 'Server error'},
    };
  }
}
