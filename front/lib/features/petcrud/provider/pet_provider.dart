import 'package:flutter/material.dart';
import '../model/pet_model.dart';
import '../service/pet_service.dart';

class PetProvider extends ChangeNotifier {
  List<PetModel> pets = [];
  bool loading = false;
  String? error;

  Future<void> fetchPets() async {
    loading = true;
    error = null;
    notifyListeners();

    try {
      pets = await PetService.getPets();
    } catch (e) {
      debugPrint('[PetProvider] fetchPets error: $e');
      pets = [];
      error = 'Failed to load pets';
    }

    loading = false;
    notifyListeners();
  }

  Future<void> addPet(PetModel pet) async {
    try {
      final created = await PetService.addPet(pet);
      pets.add(created);
      notifyListeners();
    } catch (e) {
      debugPrint('[PetProvider] addPet error: $e');
    }
  }

  Future<void> updatePet(int id, PetModel pet) async {
    try {
      final updated = await PetService.updatePet(id, pet);
      final index = pets.indexWhere((p) => p.id == id);
      if (index != -1) {
        pets[index] = updated;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('[PetProvider] updatePet error: $e');
    }
  }

  Future<void> deletePet(int id) async {
    try {
      await PetService.deletePet(id);
      pets.removeWhere((p) => p.id == id);
      notifyListeners();
    } catch (e) {
      debugPrint('[PetProvider] deletePet error: $e');
    }
  }
}
