import 'package:front/features/order_checkout/network/api_client.dart';

import '../models/appointment_model.dart';
import '../models/doctor_model.dart';
import '../models/doctor_schedule_model.dart';
import '../models/specialty_model.dart';
import '../models/working_hour_model.dart';

class VetService {
  final ApiClient _client;

  const VetService({ApiClient? client}) : _client = client ?? const ApiClient();

  Future<List<DoctorModel>> fetchDoctors() async {
    final response = await _client.getJson('/api/doctors');
    return _extractList(response).map(DoctorModel.fromJson).toList();
  }

  Future<DoctorModel> fetchDoctor(int id) async {
    final response = await _client.getJson('/api/doctors/$id');
    return DoctorModel.fromJson(_extractData(response));
  }

  Future<DoctorScheduleModel> fetchDoctorSchedule({
    required int doctorId,
    String? date,
    int slotDurationMinutes = 30,
    int? ignoreAppointmentId,
  }) async {
    final query = <String, String>{};

    if (date != null && date.trim().isNotEmpty) {
      query['date'] = date.trim();
    }

    query['slot_duration_minutes'] = slotDurationMinutes.toString();

    if (ignoreAppointmentId != null && ignoreAppointmentId > 0) {
      query['ignore_appointment_id'] = ignoreAppointmentId.toString();
    }

    final response = await _client.getJson(
      _buildPath(
        '/api/doctors/$doctorId/schedule',
        queryParameters: query.isEmpty ? null : query,
      ),
    );

    return DoctorScheduleModel.fromJson(_extractSchedulePayload(response));
  }

  Future<List<WorkingHourModel>> fetchSchedule(int doctorId) async {
    final schedule = await fetchDoctorSchedule(doctorId: doctorId);
    final doctor = schedule.doctor;
    if (doctor == null) return const [];

    return doctor.workingHours;
  }

  Future<List<SpecialtyModel>> fetchSpecialties() async {
    final response = await _client.getJson('/api/specialties');
    return _extractList(response).map(SpecialtyModel.fromJson).toList();
  }

  Future<List<AppointmentModel>> fetchAppointments() async {
    final response = await _client.getJson('/api/appointments');
    return _extractList(response).map(AppointmentModel.fromJson).toList();
  }

  Future<AppointmentModel> fetchAppointment(int id) async {
    final response = await _client.getJson('/api/appointments/$id');
    return AppointmentModel.fromJson(_extractData(response));
  }

  Future<AppointmentModel> bookAppointment({
    required int petId,
    required int doctorProfileId,
    required String appointmentDate,
    required String appointmentTime,
    required String reason,
    int durationMinutes = 30,
  }) async {
    final response = await _client.postJson('/api/appointments', {
      'pet_id': petId,
      'doctor_profile_id': doctorProfileId,
      'appointment_date': appointmentDate,
      'appointment_time': appointmentTime,
      'duration_minutes': durationMinutes,
      'reason': reason,
    });
    return AppointmentModel.fromJson(_extractData(response));
  }

  Future<AppointmentModel> rescheduleAppointment({
    required int id,
    required String appointmentDate,
    required String appointmentTime,
  }) async {
    final response = await _client.patchJson(
      '/api/appointments/$id/reschedule',
      {
        'appointment_date': appointmentDate,
        'appointment_time': appointmentTime,
      },
    );
    return AppointmentModel.fromJson(_extractData(response));
  }

  Future<AppointmentModel> cancelAppointment(int id) async {
    final response = await _client.patchJson(
      '/api/appointments/$id/cancel',
      const {},
    );
    return AppointmentModel.fromJson(_extractData(response));
  }

  String _buildPath(String path, {Map<String, String>? queryParameters}) {
    if (queryParameters == null || queryParameters.isEmpty) return path;

    final uri = Uri(path: path, queryParameters: queryParameters);
    return uri.toString();
  }

  dynamic _extractSchedulePayload(dynamic response) {
    if (response is Map<String, dynamic>) {
      final candidates = [
        response['data'],
        response['schedule'],
        response['availability'],
        response['result'],
      ];

      for (final candidate in candidates) {
        if (candidate is Map<String, dynamic> || candidate is List) {
          return candidate;
        }
      }
    }

    return response;
  }

  Map<String, dynamic> _extractData(dynamic response) {
    if (response is Map<String, dynamic>) {
      final data = response['data'];
      if (data is Map<String, dynamic>) return data;
      if (response['appointment'] is Map<String, dynamic>) {
        return response['appointment'] as Map<String, dynamic>;
      }
      return response;
    }
    throw Exception('Unexpected response format');
  }

  List<Map<String, dynamic>> _extractList(dynamic response) {
    if (response is List) {
      return response.whereType<Map<String, dynamic>>().toList();
    }
    if (response is Map<String, dynamic>) {
      final data = response['data'];
      if (data is List) {
        return data.whereType<Map<String, dynamic>>().toList();
      }
      if (response['appointments'] is List) {
        return (response['appointments'] as List)
            .whereType<Map<String, dynamic>>()
            .toList();
      }
    }
    return const [];
  }
}
