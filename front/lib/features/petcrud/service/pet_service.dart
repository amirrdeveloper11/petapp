import 'package:front/core/services/network.dart';
import '../model/pet_model.dart';

class PetService {
  PetService._();

  static Future<List<PetModel>> getPets() async {
    final res = await AppDio.dio.get('/auth/pets');
    return (res.data['data'] as List).map((e) => PetModel.fromJson(e)).toList();
  }

  static Future<PetModel> addPet(PetModel pet) async {
    final res = await AppDio.dio.post('/auth/pets', data: pet.toJson());
    return PetModel.fromJson(res.data['data']);
  }

  static Future<PetModel> updatePet(int id, PetModel pet) async {
    final res = await AppDio.dio.put('/auth/pets/$id', data: pet.toJson());
    return PetModel.fromJson(res.data['data']);
  }

  static Future<void> deletePet(int id) async {
    await AppDio.dio.delete('/auth/pets/$id');
  }
}
