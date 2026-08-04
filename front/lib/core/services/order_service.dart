import 'package:front/core/network/api_config.dart';
import 'package:front/core/network/api_exception.dart';
import 'package:front/core/network/api_response_parser.dart';
import 'package:front/core/network/base_api_service.dart';
import 'package:front/features/order/model/order_model.dart';
import 'package:front/features/order/model/order_request.dart';


class OrderService extends BaseApiService {
   OrderService();

  Future<List<OrderModel>> fetchOrders() async {
    final response = await getJson(ApiConfig.orders);
    final list = ApiResponseParser.list(
      response.data,
      keys: const ['data', 'orders', 'result'],
    );

    return list.map(OrderModel.fromJson).toList();
  }

  Future<OrderModel> fetchOrder(int id) async {
    final response = await getJson(ApiConfig.orderById(id));
    return _extractOrder(response.data);
  }

  Future<OrderModel> createOrder(OrderRequest request) async {
    final response = await postJson(ApiConfig.orders, request.toJson());
    return _extractOrder(response.data);
  }

  Future<OrderModel> cancelOrder(int id) async {
    final response = await patchJson(
      ApiConfig.orderCancel(id),
      const {},
    );

    return _extractOrder(response.data);
  }

  OrderModel _extractOrder(dynamic response) {
    final map = ApiResponseParser.map(
      response,
      keys: const ['data', 'order', 'result'],
    );

    if (map.isNotEmpty) {
      return OrderModel.fromJson(map);
    }

    if (response is List &&
        response.isNotEmpty &&
        response.first is Map) {
      return OrderModel.fromJson(
        Map<String, dynamic>.from(response.first as Map),
      );
    }

    throw const ApiException('Unexpected order response format');
  }
}