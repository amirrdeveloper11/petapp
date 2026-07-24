import 'dart:convert';

import 'package:front/core/services/secure_storage_service.dart';
import 'package:http/http.dart' as http;

import 'api_config.dart';
import 'api_exception.dart';

class ApiClient {
  const ApiClient();

  Future<Map<String, String>> _headers({bool jsonBody = true}) async {
    final headers = <String, String>{'Accept': 'application/json'};

    if (jsonBody) {
      headers['Content-Type'] = 'application/json';
    }

    final token = await SecureStorageService.readAccessToken();
    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }

    return headers;
  }

  Uri _uri(String path) {
    final base = ApiConfig.baseUrl.replaceAll(RegExp(r'/$'), '');
    final cleanPath = path.startsWith('/') ? path : '/$path';
    return Uri.parse('$base$cleanPath');
  }

  Future<dynamic> getJson(String path) async {
    final response = await http
        .get(_uri(path), headers: await _headers(jsonBody: false))
        .timeout(const Duration(seconds: 30));

    return _decodeResponse(response);
  }

  Future<dynamic> postJson(String path, Map<String, dynamic> body) async {
    final response = await http
        .post(_uri(path), headers: await _headers(), body: jsonEncode(body))
        .timeout(const Duration(seconds: 30));

    return _decodeResponse(response);
  }

  Future<dynamic> patchJson(String path, Map<String, dynamic> body) async {
    final response = await http
        .patch(_uri(path), headers: await _headers(), body: jsonEncode(body))
        .timeout(const Duration(seconds: 30));

    return _decodeResponse(response);
  }

  Future<dynamic> deleteJson(String path) async {
    final response = await http
        .delete(_uri(path), headers: await _headers(jsonBody: false))
        .timeout(const Duration(seconds: 30));

    return _decodeResponse(response);
  }

  dynamic _decodeResponse(http.Response response) {
    final statusCode = response.statusCode;
    final body = response.body.trim();

    dynamic decoded;
    if (body.isNotEmpty) {
      try {
        decoded = jsonDecode(utf8.decode(response.bodyBytes));
      } catch (_) {
        decoded = body;
      }
    }

    if (statusCode >= 200 && statusCode < 300) {
      return decoded;
    }

    final message = _extractErrorMessage(decoded) ?? 'Request failed';
    throw ApiException(message, statusCode: statusCode);
  }

  String? _extractErrorMessage(dynamic decoded) {
    if (decoded is Map<String, dynamic>) {
      final candidates = [
        decoded['message'],
        decoded['error'],
        decoded['error_message'],
      ];

      for (final candidate in candidates) {
        if (candidate is String && candidate.trim().isNotEmpty) {
          return candidate.trim();
        }
      }

      final errors = decoded['errors'];
      if (errors is Map<String, dynamic>) {
        for (final entry in errors.entries) {
          final value = entry.value;
          if (value is List && value.isNotEmpty && value.first is String) {
            return value.first as String;
          }
          if (value is String && value.isNotEmpty) return value;
        }
      }
    }

    if (decoded is String && decoded.trim().isNotEmpty) {
      return decoded.trim();
    }

    return null;
  }
}
