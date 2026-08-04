import 'package:front/core/network/api_config.dart';
import 'package:front/core/network/api_exception.dart';
import 'package:front/core/network/api_response_parser.dart';
import 'package:front/core/network/base_api_service.dart';
import 'package:front/features/locations/model/delivery_address_model.dart';


class DeliveryAddressService extends BaseApiService {
   DeliveryAddressService();

  Future<List<DeliveryAddressModel>> fetchAddresses() async {
    final response = await getJson(ApiConfig.deliveryAddresses);
    final list = ApiResponseParser.list(
      response.data,
      keys: const ['data', 'addresses', 'result'],
    );

    return list.map(DeliveryAddressModel.fromJson).toList();
  }

  Future<DeliveryAddressModel> createAddress(
    DeliveryAddressModel address,
  ) async {
    final response = await postJson(
      ApiConfig.deliveryAddresses,
      address.toJson(),
    );

    return _extractAddress(response.data);
  }

  Future<DeliveryAddressModel> updateAddress(
    int id,
    DeliveryAddressModel address,
  ) async {
    final response = await patchJson(
      ApiConfig.deliveryAddressById(id),
      address.toJson(),
    );

    return _extractAddress(response.data);
  }

  Future<void> deleteAddress(int id) async {
    await deleteJson(ApiConfig.deliveryAddressById(id));
  }

  DeliveryAddressModel _extractAddress(dynamic response) {
    final map = ApiResponseParser.map(
      response,
      keys: const ['data', 'address', 'result'],
    );

    if (map.isEmpty) {
      throw const ApiException('Unexpected delivery address response format');
    }

    return DeliveryAddressModel.fromJson(map);
  }
}