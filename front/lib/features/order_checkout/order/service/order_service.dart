import 'package:front/features/order_checkout/network/api_client.dart';
import 'package:front/features/order_checkout/network/api_config.dart';

import '../model/order_model.dart';
import '../model/order_request.dart';

class OrderService {
  final ApiClient _client;

  const OrderService({ApiClient? client})
    : _client = client ?? const ApiClient();

  Future<List<OrderModel>> fetchOrders() async {
    final response = await _client.getJson(ApiConfig.orders);
    final list = _extractList(response);

    return list
        .whereType<Map<String, dynamic>>()
        .map(OrderModel.fromJson)
        .toList();
  }

  Future<OrderModel> fetchOrder(int id) async {
    final response = await _client.getJson(ApiConfig.orderById(id));
    return _extractOrder(response);
  }

  Future<OrderModel> createOrder(OrderRequest request) async {
    final response = await _client.postJson(ApiConfig.orders, request.toJson());
    return _extractOrder(response);
  }

  Future<OrderModel> cancelOrder(int id) async {
    final response = await _client.patchJson(
      '${ApiConfig.orders}/$id/cancel',
      const {},
    );
    return _extractOrder(response);
  }

  OrderModel _extractOrder(dynamic response) {
    if (response is Map<String, dynamic>) {
      final candidate =
          response['data'] ?? response['order'] ?? response['result'];
      if (candidate is Map<String, dynamic>) {
        return OrderModel.fromJson(candidate);
      }
      return OrderModel.fromJson(response);
    }

    if (response is List &&
        response.isNotEmpty &&
        response.first is Map<String, dynamic>) {
      return OrderModel.fromJson(response.first as Map<String, dynamic>);
    }

    throw Exception('Unexpected order response format');
  }

  List<Map<String, dynamic>> _extractList(dynamic response) {
    if (response is List) {
      return response.whereType<Map<String, dynamic>>().toList();
    }

    if (response is Map<String, dynamic>) {
      final candidate =
          response['data'] ?? response['orders'] ?? response['result'];
      if (candidate is List) {
        return candidate.whereType<Map<String, dynamic>>().toList();
      }
      if (candidate is Map<String, dynamic>) {
        final nested = candidate['items'] ?? candidate['orders'];
        if (nested is List) {
          return nested.whereType<Map<String, dynamic>>().toList();
        }
      }
    }

    return const [];
  }
}
