import 'package:flutter/material.dart';
import '../model/pet_model.dart';
import 'dart:math';

class PetProvider extends ChangeNotifier {
  final List<PetModel> _pets = [];

  List<PetModel> get pets => List.unmodifiable(_pets);

  void addPet(PetModel pet) {
    _pets.add(pet);
    notifyListeners();
  }

  void updatePet(String id, PetModel pet) {
    final index = _pets.indexWhere((p) => p.id == id);
    if (index != -1) {
      _pets[index] = pet;
      notifyListeners();
    }
  }

  void deletePet(String id) {
    _pets.removeWhere((p) => p.id == id);
    notifyListeners();
  }

  String generateId() => Random().nextInt(999999).toString();
}
