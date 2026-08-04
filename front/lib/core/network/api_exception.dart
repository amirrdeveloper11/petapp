import 'package:dio/dio.dart';

class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic details;

  const ApiException(
    this.message, {
    this.statusCode,
    this.details,
  });

  factory ApiException.fromDioException(DioException error) {
    final statusCode = error.response?.statusCode;
    final responseData = error.response?.data;

    final message =
        _extractMessage(responseData) ??
        _messageFromType(error.type) ??
        error.message ??
        'Server error';

    return ApiException(
      message,
      statusCode: statusCode,
      details: responseData,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'statusCode': statusCode ?? 500,
      'body': {
        'message': message,
        if (details != null) 'details': details,
      },
    };
  }

  static String? _extractMessage(dynamic data) {
    if (data == null) return null;

    if (data is String) {
      final trimmed = data.trim();
      if (trimmed.isEmpty) return null;
      if (trimmed.startsWith('<')) return null;
      return trimmed;
    }

    if (data is Map) {
      final map = Map<String, dynamic>.from(data);

      final candidates = [
        map['message'],
        map['error'],
        map['error_message'],
        map['detail'],
        map['details'],
        map['title'],
      ];

      for (final candidate in candidates) {
        if (candidate is String && candidate.trim().isNotEmpty) {
          return candidate.trim();
        }
      }

      final errors = map['errors'];
      if (errors is Map) {
        final errorMap = Map<String, dynamic>.from(errors);
        for (final entry in errorMap.entries) {
          final value = entry.value;

          if (value is List && value.isNotEmpty) {
            final first = value.first;
            if (first is String && first.trim().isNotEmpty) {
              return first.trim();
            }
          }

          if (value is String && value.trim().isNotEmpty) {
            return value.trim();
          }
        }
      }
    }

    return null;
  }

  static String? _messageFromType(DioExceptionType type) {
    switch (type) {
      case DioExceptionType.connectionTimeout:
        return 'Connection timeout';
      case DioExceptionType.sendTimeout:
        return 'Send timeout';
      case DioExceptionType.receiveTimeout:
        return 'Receive timeout';
      case DioExceptionType.badCertificate:
        return 'Bad certificate';
      case DioExceptionType.cancel:
        return 'Request cancelled';
      case DioExceptionType.connectionError:
        return 'No internet connection';
      case DioExceptionType.badResponse:
      case DioExceptionType.unknown:
        return null;
    }
  }

  @override
  String toString() {
    if (statusCode == null) return message;
    return 'ApiException($statusCode): $message';
  }
}