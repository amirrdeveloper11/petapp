import 'package:front/core/network/api_config.dart';
import 'package:front/core/network/api_exception.dart';
import 'package:front/core/network/api_response_parser.dart';
import 'package:front/core/network/dio_client.dart';
import 'package:front/features/petcrud/model/pet_model.dart';


class PetService {
  PetService._();

  static final _dio = DioClient.instance;

  static Future<List<PetModel>> getPets() async {
    try {
      final res = await _dio.get(ApiConfig.pets);
      final list = ApiResponseParser.list(
        res.data,
        keys: const ['data', 'pets', 'result'],
      );

      return list.map(PetModel.fromJson).toList();
    } on Exception catch (e) {
      if (e is ApiException) rethrow;
      rethrow;
    }
  }

  static Future<PetModel> addPet(PetModel pet) async {
    try {
      final res = await _dio.post(ApiConfig.pets, data: pet.toJson());
      final map = ApiResponseParser.map(
        res.data,
        keys: const ['data', 'pet', 'result'],
      );
      return PetModel.fromJson(map.isEmpty ? res.data : map);
    } on Exception catch (e) {
      if (e is ApiException) rethrow;
      rethrow;
    }
  }

  static Future<PetModel> updatePet(int id, PetModel pet) async {
    try {
      final res = await _dio.put(ApiConfig.petById(id), data: pet.toJson());
      final map = ApiResponseParser.map(
        res.data,
        keys: const ['data', 'pet', 'result'],
      );
      return PetModel.fromJson(map.isEmpty ? res.data : map);
    } on Exception catch (e) {
      if (e is ApiException) rethrow;
      rethrow;
    }
  }

  static Future<void> deletePet(int id) async {
    try {
      await _dio.delete(ApiConfig.petById(id));
    } on Exception catch (e) {
      if (e is ApiException) rethrow;
      rethrow;
    }
  }
}