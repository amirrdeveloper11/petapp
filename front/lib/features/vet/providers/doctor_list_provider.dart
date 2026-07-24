import 'package:flutter/material.dart';

import '../models/doctor_model.dart';
import '../models/specialty_model.dart';
import '../services/vet_service.dart';

class DoctorListProvider extends ChangeNotifier {
  DoctorListProvider({VetService? service}) : _service = service ??  VetService();

  final VetService _service;

  List<DoctorModel> _doctors = [];
  List<SpecialtyModel> _specialties = [];
  int? _selectedSpecialtyId;
  bool _loading = false;
  String? _error;

  List<DoctorModel> get doctors => _doctors;
  List<SpecialtyModel> get specialties => _specialties;
  int? get selectedSpecialtyId => _selectedSpecialtyId;
  bool get loading => _loading;
  String? get error => _error;

  List<DoctorModel> get filteredDoctors {
    if (_selectedSpecialtyId == null) return _doctors;
    return _doctors.where((e) => e.specialty?.id == _selectedSpecialtyId).toList();
  }

  Future<void> load() async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      final res = await Future.wait([
        _service.fetchDoctors(),
        _service.fetchSpecialties(),
      ]);
      _doctors = res[0] as List<DoctorModel>;
      _specialties = res[1] as List<SpecialtyModel>;
    } catch (e) {
      _error = e.toString();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  void selectSpecialty(int? id) {
    if (_selectedSpecialtyId == id) return;
    _selectedSpecialtyId = id;
    notifyListeners();
  }
}
