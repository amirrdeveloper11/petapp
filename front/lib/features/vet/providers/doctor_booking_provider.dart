import 'package:flutter/material.dart';
import 'package:front/features/petcrud/model/pet_model.dart';
import 'package:front/core/services/pet_service.dart';

import '../models/appointment_model.dart';
import '../models/doctor_model.dart';
import '../models/doctor_schedule_model.dart';
import '../../../core/services/vet_service.dart';

class DoctorBookingProvider extends ChangeNotifier {
  DoctorBookingProvider({VetService? service})
    : _service = service ?? VetService();

  final VetService _service;

  DoctorModel? _doctor;
  DoctorScheduleModel? _schedule;

  List<PetModel> _pets = [];
  PetModel? _selectedPet;

  DateTime? _selectedDate;
  String? _selectedSlot;
  String _reason = '';

  bool _loading = false;
  bool _scheduleLoading = false;
  bool _submitting = false;
  String? _error;
  String? _scheduleError;
  AppointmentModel? _booked;

  DoctorModel? get doctor => _doctor;
  List<PetModel> get pets => _pets;
  PetModel? get selectedPet => _selectedPet;
  DateTime? get selectedDate => _selectedDate;
  String? get selectedSlot => _selectedSlot;
  String get reason => _reason;
  bool get loading => _loading;
  bool get scheduleLoading => _scheduleLoading;
  bool get submitting => _submitting;
  String? get error => _error;
  String? get scheduleError => _scheduleError;
  AppointmentModel? get booked => _booked;

  bool get hasPets => _pets.isNotEmpty;

  List<String> get availableSlots {
    if (_selectedDate == null) return const [];
    return _schedule?.availableSlots ?? const [];
  }

  bool get canBook =>
      _doctor != null &&
      _selectedPet != null &&
      _selectedDate != null &&
      _selectedSlot != null &&
      availableSlots.contains(_selectedSlot) &&
      _reason.trim().length >= 3 &&
      !_submitting &&
      !_scheduleLoading &&
      _scheduleError == null;

  Future<void> loadDoctor(int doctorId) async {
    _loading = true;
    _error = null;
    _doctor = null;
    _schedule = null;
    _pets = [];
    _selectedPet = null;
    _selectedDate = null;
    _selectedSlot = null;
    _reason = '';
    _booked = null;
    _scheduleLoading = false;
    _scheduleError = null;
    notifyListeners();

    try {
      final results = await Future.wait([
        _service.fetchDoctor(doctorId),
        PetService.getPets(),
      ]);

      _doctor = results[0] as DoctorModel;
      _pets = results[1] as List<PetModel>;
      _selectedPet = _pets.isNotEmpty ? _pets.first : null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  void selectPet(PetModel pet) {
    if (_selectedPet?.id == pet.id) return;
    _selectedPet = pet;
    notifyListeners();
  }

  Future<void> selectDate(DateTime date) async {
    final normalized = DateUtils.dateOnly(date);
    final doctor = _doctor;
    if (doctor == null) return;

    _selectedDate = normalized;
    _selectedSlot = null;
    _schedule = null;
    _scheduleError = null;
    _scheduleLoading = true;
    notifyListeners();

    final requestedDate = _formatDate(normalized);

    try {
      final schedule = await _service.fetchDoctorSchedule(
        doctorId: doctor.id,
        date: requestedDate,
      );

      if (_selectedDate == null ||
          !DateUtils.isSameDay(_selectedDate!, normalized)) {
        return;
      }

      _schedule = schedule;
      _scheduleError = null;
    } catch (e) {
      if (_selectedDate != null &&
          DateUtils.isSameDay(_selectedDate!, normalized)) {
        _scheduleError = e.toString();
        _schedule = null;
        _selectedSlot = null;
      }
    } finally {
      if (_selectedDate != null &&
          DateUtils.isSameDay(_selectedDate!, normalized)) {
        _scheduleLoading = false;
        notifyListeners();
      }
    }
  }

  void selectSlot(String slot) {
    if (_selectedSlot == slot) return;
    _selectedSlot = slot;
    notifyListeners();
  }

  void setReason(String value) {
    if (_reason == value) return;
    _reason = value;
    notifyListeners();
  }

  List<DateTime> get availableDates {
    final doctor = _doctor;
    if (doctor == null) return const [];

    final days = doctor.workingHours
        .map((e) => e.dayOfWeek.toLowerCase())
        .toSet();
    final today = DateUtils.dateOnly(DateTime.now());
    final result = <DateTime>[];

    for (int i = 0; i < 30; i++) {
      final d = today.add(Duration(days: i));
      final name = _weekdayName(d.weekday);

      if (days.isEmpty || days.contains(name)) {
        result.add(d);
      }
    }

    return result;
  }

  Future<AppointmentModel> book() async {
    if (!canBook) {
      throw Exception('Missing required fields');
    }

    _submitting = true;
    _error = null;
    notifyListeners();

    try {
      final selectedDate = _selectedDate!;
      final selectedSlot = _selectedSlot!;
      final res = await _service.bookAppointment(
        petId: _selectedPet!.id,
        doctorProfileId: _doctor!.id,
        appointmentDate: _formatDate(selectedDate),
        appointmentTime: selectedSlot,
        reason: _reason,
      );

      _booked = res;
      _selectedSlot = null;

      if (_schedule != null) {
        _schedule = _schedule!.copyWith(
          availableSlots: _schedule!.availableSlots
              .where((slot) => slot != selectedSlot)
              .toList(),
        );
      }

      notifyListeners();
      return res;
    } finally {
      _submitting = false;
      notifyListeners();
    }
  }

  String _formatDate(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  String _weekdayName(int w) {
    const map = {
      1: 'monday',
      2: 'tuesday',
      3: 'wednesday',
      4: 'thursday',
      5: 'friday',
      6: 'saturday',
      7: 'sunday',
    };
    return map[w]!;
  }
}
