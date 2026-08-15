import 'specialty_model.dart';
import 'working_hour_model.dart';

class DoctorModel {
  final int id;
  final String fullName;
  final String? licenseNumber;
  final String? phone;
  final String? bio;
  final double consultationFee;
  final bool isAvailable;
  final SpecialtyModel? specialty;

  /// Raw doctor shift windows from backend.
  /// Example: Monday 09:00-17:00
  final List<WorkingHourModel> workingHours;

  /// Real bookable slots returned by schedule endpoint.
  final List<String> availableSlots;

  /// Already booked slots returned by schedule endpoint.
  final List<String> bookedSlots;

  const DoctorModel({
    required this.id,
    required this.fullName,
    this.licenseNumber,
    this.phone,
    this.bio,
    required this.consultationFee,
    required this.isAvailable,
    this.specialty,
    this.workingHours = const [],
    this.availableSlots = const [],
    this.bookedSlots = const [],
  });

  factory DoctorModel.fromJson(Map<String, dynamic> json) {
    final whRaw = json['working_hours'] ?? json['workingHours'];
    final workingHours = whRaw is List
        ? whRaw
            .whereType<Map<String, dynamic>>()
            .map(WorkingHourModel.fromJson)
            .toList()
        : const <WorkingHourModel>[];

    final availableSlots = _parseSlots(
      json['available_slots'] ??
          json['availableSlots'] ??
          json['slots'] ??
          json['time_slots'] ??
          json['timeSlots'],
    );

    final bookedSlots = _parseSlots(
      json['booked_slots'] ??
          json['bookedSlots'] ??
          json['unavailable_slots'] ??
          json['unavailableSlots'],
    );

    final specRaw = json['specialty'];
    final SpecialtyModel? specialty = specRaw is Map<String, dynamic>
        ? SpecialtyModel.fromJson(specRaw)
        : (json['specialty_name'] != null || json['specialtyName'] != null)
            ? SpecialtyModel(
                id: _toInt(json['specialty_id']),
                name: _toString(
                  json['specialty_name'] ?? json['specialtyName'],
                  fallback: 'Specialty',
                ),
                description: null,
              )
            : null;

    return DoctorModel(
      id: _toInt(json['id']),
      fullName: _toString(
        json['full_name'] ?? json['fullName'] ?? json['name'],
        fallback: 'Doctor',
      ),
      licenseNumber: _toStringNullable(
        json['license_number'] ?? json['licenseNumber'],
      ),
      phone: _toStringNullable(json['phone']),
      bio: _toStringNullable(json['bio']),
      consultationFee: _toDouble(
        json['consultation_fee'] ?? json['consultationFee'],
      ),
      isAvailable:
          _toBool(json['is_available'] ?? json['isAvailable'] ?? true),
      specialty: specialty,
      workingHours: workingHours,
      availableSlots: availableSlots,
      bookedSlots: bookedSlots,
    );
  }

  static List<String> _parseSlots(dynamic value) {
    if (value is! List) return const [];

    return value
        .whereType<dynamic>()
        .map((item) {
          if (item is String) return _normalizeTime(item);
          if (item is Map<String, dynamic>) {
            final raw = item['time'] ??
                item['slot'] ??
                item['start_time'] ??
                item['startTime'] ??
                item['appointment_time'] ??
                item['appointmentTime'] ??
                item['available_time'] ??
                item['availableTime'];
            return _normalizeTime(raw?.toString() ?? '');
          }
          return _normalizeTime(item.toString());
        })
        .where((e) => e.isNotEmpty)
        .toSet()
        .toList()
      ..sort(_compareTime);
  }

  static String _normalizeTime(String raw) {
    final text = raw.trim();
    if (text.isEmpty) return '';

    final match = RegExp(
      r'^(\d{1,2}):(\d{2})(?::\d{2})?(?:\s*([AaPp][Mm]))?$',
    ).firstMatch(text);

    if (match != null) {
      var hour = int.tryParse(match.group(1) ?? '') ?? 0;
      final minute = int.tryParse(match.group(2) ?? '') ?? 0;
      final amPm = (match.group(3) ?? '').toLowerCase();

      if (amPm.isNotEmpty) {
        if (amPm == 'pm' && hour != 12) hour += 12;
        if (amPm == 'am' && hour == 12) hour = 0;
      }

      return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
    }

    final parsed = DateTime.tryParse(text);
    if (parsed != null) {
      return '${parsed.hour.toString().padLeft(2, '0')}:${parsed.minute.toString().padLeft(2, '0')}';
    }

    return text;
  }

  static int _compareTime(String a, String b) {
    return _toMinutes(a).compareTo(_toMinutes(b));
  }

  static int _toMinutes(String slot) {
    final parts = slot.split(':');
    if (parts.length < 2) return 0;
    final h = int.tryParse(parts[0]) ?? 0;
    final m = int.tryParse(parts[1]) ?? 0;
    return h * 60 + m;
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

  static bool _toBool(dynamic value) {
    if (value is bool) return value;
    final text = value?.toString().trim().toLowerCase() ?? '';
    return text == '1' || text == 'true' || text == 'yes';
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