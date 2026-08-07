import 'package:front/features/petcrud/model/pet_model.dart';

class AppointmentDoctorModel {
  final int id;
  final String fullName;
  final double consultationFee;
  final String? specialtyName;

  const AppointmentDoctorModel({
    required this.id,
    required this.fullName,
    required this.consultationFee,
    this.specialtyName,
  });

  factory AppointmentDoctorModel.fromJson(Map<String, dynamic> json) {
    final specialty = json['specialty'];

    return AppointmentDoctorModel(
      id: int.tryParse('${json['id']}') ?? 0,
      fullName:
          json['full_name'] ?? json['fullName'] ?? json['name'] ?? 'Doctor',
      consultationFee:
          double.tryParse(
            '${json['consultation_fee'] ?? json['consultationFee'] ?? 0}',
          ) ??
          0,
      specialtyName: specialty is Map
          ? specialty['name']?.toString()
          : json['specialty_name']?.toString() ??
                json['specialtyName']?.toString(),
    );
  }
}

class AppointmentModel {
  final int id;
  final String appointmentDate;
  final String appointmentTime;
  final int durationMinutes;
  final String status;
  final bool isExpired;
  final bool canReschedule;
  final bool canCancel;
  final String? reason;
  final String? consultationNotes;
  final String? rejectionReason;
  final DateTime? createdAt;
  final PetModel? pet;
  final AppointmentDoctorModel? doctor;

  const AppointmentModel({
    required this.id,
    required this.appointmentDate,
    required this.appointmentTime,
    required this.durationMinutes,
    required this.status,
    required this.isExpired,
    required this.canReschedule,
    required this.canCancel,
    this.reason,
    this.consultationNotes,
    this.rejectionReason,
    this.createdAt,
    this.pet,
    this.doctor,
  });

  factory AppointmentModel.fromJson(Map<String, dynamic> json) {
    final status = '${json['status'] ?? ''}';

    final date = _normalizeDate(json['appointment_date'] ?? json['date']);

    final time = _normalizeTime(json['appointment_time'] ?? json['time']);

    final duration = int.tryParse('${json['duration_minutes'] ?? 30}') ?? 30;

    final expired =
        json['is_expired'] == true ||
        '${json['effective_status'] ?? ''}'.toLowerCase() == 'expired' ||
        (_isPending(status) && _isPastDue(date, time, duration));

    return AppointmentModel(
      id: int.tryParse('${json['id']}') ?? 0,
      appointmentDate: date,
      appointmentTime: time,
      durationMinutes: duration,
      status: status,
      isExpired: expired,

      canReschedule:
          json['can_reschedule'] == true || (!expired && _isPending(status)),

      canCancel: json['can_cancel'] == true || (!expired && _isPending(status)),

      reason: _nullable(json['reason']),

      consultationNotes: _nullable(
        json['consultation_notes'] ?? json['consultationNotes'],
      ),

      rejectionReason: _nullable(
        json['rejection_reason'] ?? json['rejectionReason'],
      ),

      createdAt: DateTime.tryParse(
        '${json['created_at'] ?? json['createdAt'] ?? ''}',
      ),

      pet: json['pet'] is Map
          ? PetModel.fromJson(Map<String, dynamic>.from(json['pet']))
          : null,

      doctor: json['doctor'] is Map
          ? AppointmentDoctorModel.fromJson(
              Map<String, dynamic>.from(json['doctor']),
            )
          : null,
    );
  }

  AppointmentModel copyWith({
    String? status,
    bool? isExpired,
    bool? canReschedule,
    bool? canCancel,
    String? appointmentDate,
    String? appointmentTime,
    String? reason,
    String? consultationNotes,
    String? rejectionReason,
    DateTime? createdAt,
    PetModel? pet,
    AppointmentDoctorModel? doctor,
  }) {
    return AppointmentModel(
      id: id,
      appointmentDate: appointmentDate ?? this.appointmentDate,
      appointmentTime: appointmentTime ?? this.appointmentTime,
      durationMinutes: durationMinutes,
      status: status ?? this.status,
      isExpired: isExpired ?? this.isExpired,
      canReschedule: canReschedule ?? this.canReschedule,
      canCancel: canCancel ?? this.canCancel,
      reason: reason ?? this.reason,
      consultationNotes: consultationNotes ?? this.consultationNotes,
      rejectionReason: rejectionReason ?? this.rejectionReason,
      createdAt: createdAt ?? this.createdAt,
      pet: pet ?? this.pet,
      doctor: doctor ?? this.doctor,
    );
  }

  bool get canRescheduleAction => canReschedule && !isTerminal;

  bool get canCancelAction => canCancel && !isTerminal;

  bool get isTerminal =>
      isExpired ||
      _isCompleted(status) ||
      _isCancelled(status) ||
      _isRejected(status);

  String get displayStatus => isExpired ? 'expired' : status;

  static bool _isPending(String status) {
    final value = status.toLowerCase();

    return value.contains('pending') ||
        value.contains('request') ||
        value.contains('await');
  }

  static bool _isCompleted(String status) {
    final value = status.toLowerCase();

    return value.contains('complete') || value.contains('done');
  }

  static bool _isCancelled(String status) {
    return status.toLowerCase().contains('cancel');
  }

  static bool _isRejected(String status) {
    final value = status.toLowerCase();

    return value.contains('reject') || value.contains('declin');
  }

  static bool _isPastDue(String date, String time, int duration) {
    if (date.isEmpty || time.isEmpty) return false;

    final dateTime = DateTime.tryParse('$date $time');

    if (dateTime == null) return false;

    return dateTime.add(Duration(minutes: duration)).isBefore(DateTime.now());
  }

  static String _normalizeDate(dynamic value) {
    final raw = value?.toString().trim() ?? '';

    if (raw.isEmpty) return '';

    final date = DateTime.tryParse(raw);

    if (date != null) {
      return '${date.year}-${_pad(date.month)}-${_pad(date.day)}';
    }

    return raw.split('T').first.split(' ').first;
  }

  static String _normalizeTime(dynamic value) {
    var raw = value?.toString().trim() ?? '';

    if (raw.isEmpty) return '';

    final match = RegExp(
      r'^(\d{1,2}):(\d{2})(?::\d{2}(?:\.\d+)?)?\s*([AaPp][Mm])?$',
    ).firstMatch(raw);

    if (match != null) {
      var hour = int.tryParse(match.group(1)!) ?? 0;
      final minute = int.tryParse(match.group(2)!) ?? 0;
      final period = match.group(3)?.toLowerCase();

      if (period == 'am' && hour == 12) {
        hour = 0;
      } else if (period == 'pm' && hour < 12) {
        hour += 12;
      }

      return '${_pad(hour)}:${_pad(minute)}';
    }

    final dateTime = DateTime.tryParse(raw);

    if (dateTime != null) {
      return '${_pad(dateTime.hour)}:${_pad(dateTime.minute)}';
    }

    final parts = raw.split(':');

    if (parts.length >= 2) {
      final hour = int.tryParse(parts[0]);
      final minute = int.tryParse(parts[1]);

      if (hour != null && minute != null) {
        return '${_pad(hour)}:${_pad(minute)}';
      }
    }

    return raw;
  }

  static String _pad(int value) {
    return value.toString().padLeft(2, '0');
  }

  static String? _nullable(dynamic value) {
    final text = value?.toString().trim() ?? '';

    return text.isEmpty ? null : text;
  }
}
