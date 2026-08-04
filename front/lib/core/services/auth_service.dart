import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:front/core/network/api_config.dart';
import 'package:front/core/network/api_exception.dart';
import 'package:front/core/network/dio_client.dart';
import 'package:front/core/secure_storage_service.dart';
import 'package:front/features/auth/user/model/user_model.dart';


class AuthServiceDio {
  AuthServiceDio._();

  static final Dio _dio = DioClient.instance;

  static Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
  }) {
    return _post(
      ApiConfig.authRegister,
      {
        'name': name,
        'email': email,
        'password': password,
        'password_confirmation': passwordConfirmation,
      },
      saveAuth: true,
    );
  }

  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) {
    return _post(
      ApiConfig.authLogin,
      {
        'email': email,
        'password': password,
      },
      saveAuth: true,
    );
  }

  static Future<Map<String, dynamic>> refreshToken({
    required String refreshToken,
  }) {
    return _post(
      ApiConfig.authRefresh,
      {
        'refresh_token': refreshToken,
      },
      saveAuth: true,
    );
  }

  static Future<void> logout() async {
    try {
      await _post(ApiConfig.authLogout, {});
    } catch (_) {
    }
    await SecureStorageService.deleteAll();
  }

  static Future<Map<String, dynamic>> updateProfile({
    required String name,
    required String email,
    String? password,
  }) {
    return _post(
      ApiConfig.authUpdateProfile,
      {
        'name': name,
        'email': email,
        if (password?.isNotEmpty == true) 'password': password,
      },
      saveUserOnly: true,
    );
  }

  static Future<Map<String, dynamic>> deleteAccount() async {
    final res = await _delete(ApiConfig.authDeleteAccount);
    await SecureStorageService.deleteAll();
    return res;
  }

  static Future<UserModel?> readStoredUser() async {
    final jsonStr = await SecureStorageService.readUserJson();
    if (jsonStr == null || jsonStr.trim().isEmpty) return null;

    try {
      return UserModel.fromJson(jsonDecode(jsonStr));
    } catch (_) {
      return null;
    }
  }

  static Future<Map<String, dynamic>> _post(
    String path,
    Map<String, dynamic> data, {
    bool saveAuth = false,
    bool saveUserOnly = false,
  }) async {
    try {
      final res = await _dio.post(path, data: data);
      final body = _asMap(res.data);

      if (saveAuth) {
        await _saveAuth(body);
      } else if (saveUserOnly) {
        await _saveUser(body);
      }

      return {
        'statusCode': res.statusCode ?? 200,
        'body': body,
      };
    } on DioException catch (e) {
      return ApiException.fromDioException(e).toMap();
    }
  }

  static Future<Map<String, dynamic>> _delete(String path) async {
    try {
      final res = await _dio.delete(path);
      return {
        'statusCode': res.statusCode ?? 200,
        'body': _asMap(res.data),
      };
    } on DioException catch (e) {
      return ApiException.fromDioException(e).toMap();
    }
  }

  static Future<void> _saveAuth(Map<String, dynamic> payload) async {
    final data = _extractDataMap(payload);

    if (data == null) return;

    final accessToken =
        data['access_token'] ?? data['accessToken'] ?? data['token'];
    final refreshToken =
        data['refresh_token'] ?? data['refreshToken'];

    final user = data['user'];

    if (accessToken != null) {
      await SecureStorageService.writeAccessToken(accessToken.toString());
    }

    if (refreshToken != null) {
      await SecureStorageService.writeRefreshToken(refreshToken.toString());
    }

    if (user != null) {
      await SecureStorageService.writeUserJson(jsonEncode(user));
    }
  }

  static Future<void> _saveUser(Map<String, dynamic> payload) async {
    final data = _extractDataMap(payload);
    if (data == null) return;

    final user = data['user'] ?? data;
    await SecureStorageService.writeUserJson(jsonEncode(user));
  }

  static Map<String, dynamic> _asMap(dynamic data) {
    if (data is Map<String, dynamic>) return data;
    if (data is Map) return Map<String, dynamic>.from(data);
    return {'message': data?.toString() ?? 'Server error'};
  }

  static Map<String, dynamic>? _extractDataMap(Map<String, dynamic> payload) {
    final data = payload['data'];
    if (data is Map) return Map<String, dynamic>.from(data);

    final user = payload['user'];
    if (user is Map) return Map<String, dynamic>.from(payload);

    return payload;
  }
}