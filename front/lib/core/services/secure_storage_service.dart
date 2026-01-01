import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  static final _storage = const FlutterSecureStorage();

  static const _kAccess = 'access_token';
  static const _kRefresh = 'refresh_token';
  static const _kUser = 'user_json'; 

  // write
  static Future<void> writeAccessToken(String token) =>
      _storage.write(key: _kAccess, value: token);

  static Future<void> writeRefreshToken(String token) =>
      _storage.write(key: _kRefresh, value: token);

  static Future<void> writeUserJson(String json) =>
      _storage.write(key: _kUser, value: json);

  // read
  static Future<String?> readAccessToken() => _storage.read(key: _kAccess);
  static Future<String?> readRefreshToken() => _storage.read(key: _kRefresh);
  static Future<String?> readUserJson() => _storage.read(key: _kUser);

  // delete
  static Future<void> deleteAll() => _storage.deleteAll();
  static Future<void> deleteAccessToken() => _storage.delete(key: _kAccess);
  static Future<void> deleteRefreshToken() => _storage.delete(key: _kRefresh);
  static Future<void> deleteUserJson() => _storage.delete(key: _kUser);
}
