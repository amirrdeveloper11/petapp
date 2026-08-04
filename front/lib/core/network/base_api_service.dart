import 'package:dio/dio.dart';

import 'api_exception.dart';
import 'dio_client.dart';

abstract class BaseApiService {
  BaseApiService();

  Dio get dio => DioClient.instance;

  Future<Response<dynamic>> getJson(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      return await dio.get(
        path,
        queryParameters: queryParameters,
      );
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<Response<dynamic>> postJson(
    String path,
    Map<String, dynamic> body,
  ) async {
    try {
      return await dio.post(path, data: body);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<Response<dynamic>> putJson(
    String path,
    Map<String, dynamic> body,
  ) async {
    try {
      return await dio.put(path, data: body);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<Response<dynamic>> patchJson(
    String path,
    Map<String, dynamic> body,
  ) async {
    try {
      return await dio.patch(path, data: body);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<Response<dynamic>> deleteJson(
    String path, {
    Map<String, dynamic>? body,
  }) async {
    try {
      return await dio.delete(path, data: body);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }
}