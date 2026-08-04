

import 'package:front/core/network/api_config.dart';
import 'package:front/core/network/api_exception.dart';
import 'package:front/core/network/api_response_parser.dart';
import 'package:front/core/network/base_api_service.dart';
import 'package:front/features/vet/models/appointment_model.dart';
import 'package:front/features/vet/models/doctor_model.dart';
import 'package:front/features/vet/models/doctor_schedule_model.dart';
import 'package:front/features/vet/models/specialty_model.dart';
import 'package:front/features/vet/models/working_hour_model.dart';

class VetService extends BaseApiService {
   VetService();

  Future<List<DoctorModel>> fetchDoctors() async {
    final response = await getJson(ApiConfig.doctors);
    final list = ApiResponseParser.list(
      response.data,
      keys: const ['data', 'doctors', 'result'],
    );

    return list.map(DoctorModel.fromJson).toList();
  }

  Future<DoctorModel> fetchDoctor(int id) async {
    final response = await getJson(ApiConfig.doctorById(id));
    final map = ApiResponseParser.map(
      response.data,
      keys: const ['data', 'doctor', 'result'],
    );

    if (map.isEmpty) {
      throw const ApiException('Unexpected doctor response format');
    }

    return DoctorModel.fromJson(map);
  }

  Future<DoctorScheduleModel> fetchDoctorSchedule({
    required int doctorId,
    String? date,
    int slotDurationMinutes = 30,
    int? ignoreAppointmentId,
  }) async {
    final query = <String, dynamic>{
      'slot_duration_minutes': slotDurationMinutes,
    };

    if (date != null && date.trim().isNotEmpty) {
      query['date'] = date.trim();
    }

    if (ignoreAppointmentId != null && ignoreAppointmentId > 0) {
      query['ignore_appointment_id'] = ignoreAppointmentId;
    }

    final response = await getJson(
      ApiConfig.doctorSchedule(doctorId),
      queryParameters: query,
    );

    final payload = ApiResponseParser.extract(
      response.data,
      keys: const ['data', 'schedule', 'availability', 'result'],
    );

    return DoctorScheduleModel.fromJson(payload);
  }

  Future<List<WorkingHourModel>> fetchSchedule(int doctorId) async {
    final schedule = await fetchDoctorSchedule(doctorId: doctorId);
    final doctor = schedule.doctor;
    if (doctor == null) return const [];
    return doctor.workingHours;
  }

  Future<List<SpecialtyModel>> fetchSpecialties() async {
    final response = await getJson(ApiConfig.specialties);
    final list = ApiResponseParser.list(
      response.data,
      keys: const ['data', 'specialties', 'result'],
    );

    return list.map(SpecialtyModel.fromJson).toList();
  }

  Future<List<AppointmentModel>> fetchAppointments() async {
    final response = await getJson(ApiConfig.appointments);
    final list = ApiResponseParser.list(
      response.data,
      keys: const ['data', 'appointments', 'result'],
    );

    return list.map(AppointmentModel.fromJson).toList();
  }

  Future<AppointmentModel> fetchAppointment(int id) async {
    final response = await getJson(ApiConfig.appointmentById(id));
    final map = ApiResponseParser.map(
      response.data,
      keys: const ['data', 'appointment', 'result'],
    );

    if (map.isEmpty) {
      throw const ApiException('Unexpected appointment response format');
    }

    return AppointmentModel.fromJson(map);
  }

  Future<AppointmentModel> bookAppointment({
    required int petId,
    required int doctorProfileId,
    required String appointmentDate,
    required String appointmentTime,
    required String reason,
    int durationMinutes = 30,
  }) async {
    final response = await postJson(
      ApiConfig.appointments,
      {
        'pet_id': petId,
        'doctor_profile_id': doctorProfileId,
        'appointment_date': appointmentDate,
        'appointment_time': appointmentTime,
        'duration_minutes': durationMinutes,
        'reason': reason,
      },
    );

    final map = ApiResponseParser.map(
      response.data,
      keys: const ['data', 'appointment', 'result'],
    );

    if (map.isEmpty) {
      throw const ApiException('Unexpected appointment response format');
    }

    return AppointmentModel.fromJson(map);
  }

  Future<AppointmentModel> rescheduleAppointment({
    required int id,
    required String appointmentDate,
    required String appointmentTime,
  }) async {
    final response = await patchJson(
      ApiConfig.appointmentReschedule(id),
      {
        'appointment_date': appointmentDate,
        'appointment_time': appointmentTime,
      },
    );

    final map = ApiResponseParser.map(
      response.data,
      keys: const ['data', 'appointment', 'result'],
    );

    if (map.isEmpty) {
      throw const ApiException('Unexpected appointment response format');
    }

    return AppointmentModel.fromJson(map);
  }

  Future<AppointmentModel> cancelAppointment(int id) async {
    final response = await patchJson(
      ApiConfig.appointmentCancel(id),
      const {},
    );

    final map = ApiResponseParser.map(
      response.data,
      keys: const ['data', 'appointment', 'result'],
    );

    if (map.isEmpty) {
      throw const ApiException('Unexpected appointment response format');
    }

    return AppointmentModel.fromJson(map);
  }
}