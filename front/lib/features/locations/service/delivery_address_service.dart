import 'package:front/features/order_checkout/network/api_client.dart';
import 'package:front/features/order_checkout/network/api_config.dart';

import '../model/delivery_address_model.dart';

class DeliveryAddressService {
  final ApiClient _client;

  const DeliveryAddressService({ApiClient? client})
      : _client = client ?? const ApiClient();

  Future<List<DeliveryAddressModel>> fetchAddresses() async {
    final response = await _client.getJson(ApiConfig.deliveryAddresses);
    final list = _extractList(response);

    return list
        .whereType<Map<String, dynamic>>()
        .map(DeliveryAddressModel.fromJson)
        .toList();
  }

  Future<DeliveryAddressModel> createAddress(
    DeliveryAddressModel address,
  ) async {
    final response =
        await _client.postJson(ApiConfig.deliveryAddresses, address.toJson());
    return _extractAddress(response);
  }

  Future<DeliveryAddressModel> updateAddress(
    int id,
    DeliveryAddressModel address,
  ) async {
    final response = await _client.patchJson(
      ApiConfig.deliveryAddressById(id),
      address.toJson(),
    );
    return _extractAddress(response);
  }

  Future<void> deleteAddress(int id) async {
    await _client.deleteJson(ApiConfig.deliveryAddressById(id));
  }

  List<Map<String, dynamic>> _extractList(dynamic response) {
    if (response is List) {
      return response.whereType<Map<String, dynamic>>().toList();
    }

    if (response is Map<String, dynamic>) {
      final candidate =
          response['data'] ?? response['addresses'] ?? response['result'];

      if (candidate is List) {
        return candidate.whereType<Map<String, dynamic>>().toList();
      }
    }

    return const [];
  }

  DeliveryAddressModel _extractAddress(dynamic response) {
    if (response is Map<String, dynamic>) {
      final candidate =
          response['data'] ?? response['address'] ?? response['result'];

      if (candidate is Map<String, dynamic>) {
        return DeliveryAddressModel.fromJson(candidate);
      }

      return DeliveryAddressModel.fromJson(response);
    }

    throw Exception('Unexpected delivery address response format');
  }
}