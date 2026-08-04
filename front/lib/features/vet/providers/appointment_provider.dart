import 'package:flutter/material.dart';

import '../models/appointment_model.dart';
import '../../../core/services/vet_service.dart';

class AppointmentProvider extends ChangeNotifier {
  final VetService _service;

  AppointmentProvider({VetService? service})
    : _service = service ?? VetService();

  List<AppointmentModel> _appointments = [];
  bool _isLoading = false;
  bool _isSubmitting = false;
  String? _error;

  List<AppointmentModel> get appointments => _appointments;
  bool get isLoading => _isLoading;
  bool get isSubmitting => _isSubmitting;
  String? get error => _error;

  Future<void> fetchAppointments() async {
    _setLoading(true);
    _error = null;
    try {
      _appointments = _dedupeById(await _service.fetchAppointments());
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  Future<AppointmentModel> book({
    required int petId,
    required int doctorProfileId,
    required String appointmentDate,
    required String appointmentTime,
    required String reason,
  }) async {
    _setSubmitting(true);
    _error = null;
    try {
      final created = await _service.bookAppointment(
        petId: petId,
        doctorProfileId: doctorProfileId,
        appointmentDate: appointmentDate,
        appointmentTime: appointmentTime,
        reason: reason,
      );
      _appointments = _upsertById(created);
      notifyListeners();
      return created;
    } catch (e) {
      _error = e.toString();
      rethrow;
    } finally {
      _setSubmitting(false);
    }
  }

  Future<AppointmentModel> reschedule({
    required int id,
    required String appointmentDate,
    required String appointmentTime,
  }) async {
    _setSubmitting(true);
    _error = null;
    try {
      final updated = await _service.rescheduleAppointment(
        id: id,
        appointmentDate: appointmentDate,
        appointmentTime: appointmentTime,
      );
      _replaceLocal(updated);
      return updated;
    } catch (e) {
      _error = e.toString();
      rethrow;
    } finally {
      _setSubmitting(false);
    }
  }

  Future<AppointmentModel> cancel(int id) async {
    _setSubmitting(true);
    _error = null;
    try {
      final updated = await _service.cancelAppointment(id);
      _replaceLocal(updated);
      return updated;
    } catch (e) {
      _error = e.toString();
      rethrow;
    } finally {
      _setSubmitting(false);
    }
  }

  void replaceLocal(AppointmentModel appointment) => _replaceLocal(appointment);

  Future<void> refresh() => fetchAppointments();

  void _replaceLocal(AppointmentModel appointment) {
    _appointments = _upsertById(appointment);
    notifyListeners();
  }

  List<AppointmentModel> _upsertById(AppointmentModel appointment) {
    final next = <AppointmentModel>[];
    var replaced = false;

    for (final item in _appointments) {
      if (item.id == appointment.id) {
        if (!replaced) {
          next.add(appointment);
          replaced = true;
        }
      } else {
        next.add(item);
      }
    }

    if (!replaced) {
      next.insert(0, appointment);
    }

    return next;
  }

  List<AppointmentModel> _dedupeById(List<AppointmentModel> items) {
    final seen = <int>{};
    final result = <AppointmentModel>[];
    for (final item in items) {
      if (seen.add(item.id)) {
        result.add(item);
      }
    }
    return result;
  }

  void _setLoading(bool value) {
    if (_isLoading == value) return;
    _isLoading = value;
    notifyListeners();
  }

  void _setSubmitting(bool value) {
    if (_isSubmitting == value) return;
    _isSubmitting = value;
    notifyListeners();
  }
}
