import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:front/core/services/network.dart';
import 'package:front/core/services/secure_storage_service.dart';
import 'package:front/features/auth/user/model/user_model.dart';

class AuthServiceDio {
  AuthServiceDio._();

  static final Dio _dio = AppDio.dio;


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

  static Future<void> logout() async {
    try {
      await _post('/auth/logout', {});
    } catch (_) {}
    await SecureStorageService.deleteAll();
  }


  static Future<Map<String, dynamic>> updateProfile({
    required String name,
    required String email,
    String? password,
  }) {
    return _post(
      '/auth/update-profile',
      {
        'name': name,
        'email': email,
        if (password?.isNotEmpty == true) 'password': password,
      },
      saveUserOnly: true,
    );
  }

  static Future<Map<String, dynamic>> deleteAccount() async {
    final res = await _delete('/auth/delete-account');
    await SecureStorageService.deleteAll();
    return res;
  }

  static Future<UserModel?> readStoredUser() async {
    final jsonStr = await SecureStorageService.readUserJson();
    if (jsonStr == null) return null;
    return UserModel.fromJson(jsonDecode(jsonStr));
  }

  

  static Future<Map<String, dynamic>> _post(
    String path,
    Map<String, dynamic> data, {
    bool saveAuth = false,
    bool saveUserOnly = false,
  }) async {
    try {
      final res = await _dio.post(path, data: data);

      if (saveAuth) {
        await _saveAuth(res.data);
      } else if (saveUserOnly) {
        await _saveUser(res.data);
      }

      return _ok(res);
    } on DioException catch (e) {
      return _fail(e);
    }
  }

  static Future<Map<String, dynamic>> _delete(String path) async {
    try {
      final res = await _dio.delete(path);
      return _ok(res);
    } on DioException catch (e) {
      return _fail(e);
    }
  }


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

  static Map<String, dynamic> _fail(DioException e) => {
        'statusCode': e.response?.statusCode ?? 500,
        'body': {
          'message': e.response?.data?['message'] ?? 'Server error',
        },
      };
}
