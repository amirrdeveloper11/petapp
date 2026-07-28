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
    final specialtyRaw = json['specialty'];
    final specialtyName = specialtyRaw is Map<String, dynamic>
        ? specialtyRaw['name']
        : json['specialty_name'] ?? json['specialtyName'];

    return AppointmentDoctorModel(
      id: _toInt(json['id']),
      fullName: _toString(
        json['full_name'] ?? json['fullName'] ?? json['name'],
        fallback: 'Doctor',
      ),
      consultationFee: _toDouble(
        json['consultation_fee'] ?? json['consultationFee'],
      ),
      specialtyName: _toStringNullable(specialtyName),
    );
  }

  static int _toInt(dynamic value) {
    if (value is int) return value;
    if (value is double) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  static double _toDouble(dynamic value) {
    if (value is double) return value;
    if (value is int) return value.toDouble();
    return double.tryParse(value?.toString() ?? '') ?? 0;
  }

  static String _toString(dynamic value, {String fallback = ''}) {
    final text = value?.toString().trim() ?? '';
    return text.isEmpty ? fallback : text;
  }

  static String? _toStringNullable(dynamic value) {
    final text = value?.toString().trim() ?? '';
    return text.isEmpty ? null : text;
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
    this.isExpired = false,
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
    final petRaw = _mapFrom(json, const ['pet', 'pet_profile', 'petProfile']);
    final doctorRaw = _mapFrom(json, const [
      'doctor',
      'doctor_profile',
      'doctorProfile',
    ]);

    final status = _toString(json['status']);
    final appointmentDate = _normalizeDate(
      json['appointment_date'] ?? json['date'] ?? json['appointmentDate'],
    );
    final appointmentTime = _normalizeTime(
      json['appointment_time'] ?? json['time'] ?? json['appointmentTime'],
    );
    final durationMinutes = _toInt(
      json['duration_minutes'] ?? json['durationMinutes'],
      fallback: 30,
    );

    final isExpired =
        json.containsKey('is_expired') || json.containsKey('effective_status')
        ? (_toBool(json['is_expired']) ||
              _toString(json['effective_status']).toLowerCase() == 'expired')
        : _isPendingLike(status) &&
              _computeIsPastDue(
                appointmentDate,
                appointmentTime,
                durationMinutes,
              );

    final apiCanReschedule = _toBool(json['can_reschedule']);
    final apiCanCancel = _toBool(json['can_cancel']);
    final localPendingFallback = !isExpired && _isPendingLike(status);

    return AppointmentModel(
      id: _toInt(json['id']),
      appointmentDate: appointmentDate,
      appointmentTime: appointmentTime,
      durationMinutes: durationMinutes,
      status: status,
      isExpired: isExpired,

      canReschedule: apiCanReschedule || localPendingFallback,
      canCancel: apiCanCancel || localPendingFallback,
      reason: _toStringNullable(json['reason']),
      consultationNotes: _toStringNullable(
        json['consultation_notes'] ?? json['consultationNotes'],
      ),
      rejectionReason: _toStringNullable(
        json['rejection_reason'] ?? json['rejectionReason'],
      ),
      createdAt: _toDateTimeNullable(json['created_at'] ?? json['createdAt']),
      pet: petRaw == null ? null : PetModel.fromJson(petRaw),
      doctor: doctorRaw == null
          ? null
          : AppointmentDoctorModel.fromJson(doctorRaw),
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

  String get displayStatus => isExpired ? 'expired' : status;

  bool get isTerminal =>
      isExpired ||
      _isCompletedLike(status) ||
      _isCancelledLike(status) ||
      _isRejectedLike(status);

  static Map<String, dynamic>? _mapFrom(
    Map<String, dynamic> json,
    List<String> keys,
  ) {
    for (final key in keys) {
      final value = json[key];
      if (value is Map<String, dynamic>) return value;
    }
    return null;
  }

  static bool _isPendingLike(String value) {
    final s = value.trim().toLowerCase();
    return s.contains('pending') ||
        s.contains('request') ||
        s.contains('await');
  }

  static bool _isCancelledLike(String value) {
    final s = value.trim().toLowerCase();
    return s.contains('cancel');
  }

  static bool _isRejectedLike(String value) {
    final s = value.trim().toLowerCase();
    return s.contains('reject') || s.contains('declin');
  }

  static bool _isCompletedLike(String value) {
    final s = value.trim().toLowerCase();
    return s.contains('complete') || s.contains('done');
  }

  static bool _computeIsPastDue(
    String appointmentDate,
    String appointmentTime,
    int durationMinutes,
  ) {
    if (appointmentDate.isEmpty || appointmentTime.isEmpty) return false;

    final parts = appointmentTime.split(':');
    if (parts.length < 2) return false;

    final hour = int.tryParse(parts[0]);
    final minute = int.tryParse(parts[1]);
    final datePart = DateTime.tryParse(appointmentDate);
    if (hour == null || minute == null || datePart == null) return false;

    final start = DateTime(
      datePart.year,
      datePart.month,
      datePart.day,
      hour,
      minute,
    );
    final end = start.add(Duration(minutes: durationMinutes));

    return end.isBefore(DateTime.now());
  }

  static int _toInt(dynamic value, {int fallback = 0}) {
    if (value is int) return value;
    if (value is double) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? fallback;
  }

  static bool _toBool(dynamic value) {
    if (value is bool) return value;
    final text = value?.toString().trim().toLowerCase() ?? '';
    return text == '1' || text == 'true' || text == 'yes';
  }

  static String _toString(dynamic value) {
    final text = value?.toString().trim() ?? '';
    return text;
  }

  static String? _toStringNullable(dynamic value) {
    final text = value?.toString().trim() ?? '';
    return text.isEmpty ? null : text;
  }

  static DateTime? _toDateTimeNullable(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    return DateTime.tryParse(value.toString());
  }

  static String _normalizeDate(dynamic value) {
    final raw = value?.toString().trim() ?? '';
    if (raw.isEmpty) return '';
    final parsed = DateTime.tryParse(raw);
    if (parsed != null) {
      return '${parsed.year}-${_pad2(parsed.month)}-${_pad2(parsed.day)}';
    }
    return raw.split('T').first.split(' ').first;
  }

  static String _normalizeTime(dynamic value) {
    final raw = value?.toString().trim() ?? '';
    if (raw.isEmpty) return '';

    final parsed = RegExp(
      r'^(\d{1,2}):(\d{2})(?::\d{2})?(?:\s*([AaPp][Mm]))?$',
    ).firstMatch(raw);

    if (parsed != null) {
      var hour = int.tryParse(parsed.group(1) ?? '') ?? 0;
      final minute = int.tryParse(parsed.group(2) ?? '') ?? 0;
      final amPm = (parsed.group(3) ?? '').toLowerCase();

      if (amPm == 'am' && hour == 12) hour = 0;
      if (amPm == 'pm' && hour < 12) hour += 12;

      return '${_pad2(hour)}:${_pad2(minute)}';
    }

    final dt = DateTime.tryParse(raw);
    if (dt != null) {
      return '${_pad2(dt.hour)}:${_pad2(dt.minute)}';
    }

    return raw;
  }

  static String _pad2(int value) => value.toString().padLeft(2, '0');
}
