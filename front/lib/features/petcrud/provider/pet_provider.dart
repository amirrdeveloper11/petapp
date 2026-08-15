import 'package:flutter/material.dart';
import '../model/pet_model.dart';
import '../../../core/services/pet_service.dart';

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

  /// Adds a pet and returns the created record.
  ///
  /// Rethrows on failure (instead of swallowing the error) so the calling
  /// screen can show feedback to the user and avoid navigating away as if
  /// the save had succeeded.
  Future<PetModel> addPet(PetModel pet) async {
    try {
      final created = await PetService.addPet(pet);
      pets.add(created);
      notifyListeners();
      return created;
    } catch (e) {
      debugPrint('[PetProvider] addPet error: $e');
      rethrow;
    }
  }

  /// Updates a pet and returns the updated record. Rethrows on failure —
  /// see [addPet].
  Future<PetModel> updatePet(int id, PetModel pet) async {
    try {
      final updated = await PetService.updatePet(id, pet);
      final index = pets.indexWhere((p) => p.id == id);
      if (index != -1) {
        pets[index] = updated;
      } else {
        pets.add(updated);
      }
      notifyListeners();
      return updated;
    } catch (e) {
      debugPrint('[PetProvider] updatePet error: $e');
      rethrow;
    }
  }

  /// Deletes a pet. Rethrows on failure — see [addPet].
  Future<void> deletePet(int id) async {
    try {
      await PetService.deletePet(id);
      pets.removeWhere((p) => p.id == id);
      notifyListeners();
    } catch (e) {
      debugPrint('[PetProvider] deletePet error: $e');
      rethrow;
    }
  }
}
