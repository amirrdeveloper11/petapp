import 'doctor_model.dart';

class DoctorScheduleModel {
  final DateTime? date;
  final DoctorModel? doctor;
  final List<String> availableSlots;
  final List<String> bookedSlots;

  const DoctorScheduleModel({
    this.date,
    this.doctor,
    this.availableSlots = const [],
    this.bookedSlots = const [],
  });

  DoctorScheduleModel copyWith({
    DateTime? date,
    DoctorModel? doctor,
    List<String>? availableSlots,
    List<String>? bookedSlots,
  }) {
    return DoctorScheduleModel(
      date: date ?? this.date,
      doctor: doctor ?? this.doctor,
      availableSlots: availableSlots ?? this.availableSlots,
      bookedSlots: bookedSlots ?? this.bookedSlots,
    );
  }

  factory DoctorScheduleModel.fromJson(dynamic response) {
    if (response is List) {
      return DoctorScheduleModel(
        availableSlots: _normalizeAndSortSlots(_parseSlots(response)),
      );
    }

    if (response is! Map<String, dynamic>) {
      return const DoctorScheduleModel();
    }

    final payload = _unwrapPayload(response);

    if (payload is List) {
      return DoctorScheduleModel(
        availableSlots: _normalizeAndSortSlots(_parseSlots(payload)),
      );
    }

    if (payload is! Map<String, dynamic>) {
      return const DoctorScheduleModel();
    }

    final doctor = _extractDoctor(payload);

    final rawAvailable = payload['available_slots'] ??
        payload['availableSlots'] ??
        payload['slots'] ??
        payload['time_slots'] ??
        payload['timeSlots'];

    final rawBooked = payload['booked_slots'] ??
        payload['bookedSlots'] ??
        payload['unavailable_slots'] ??
        payload['unavailableSlots'];

    final availableSlots = _normalizeAndSortSlots(
      _parseSlots(rawAvailable),
      fallback: doctor?.availableSlots ?? const [],
    );

    final bookedSlots = _normalizeAndSortSlots(
      _parseSlots(rawBooked),
    );

    return DoctorScheduleModel(
      date: _parseDate(
        payload['date'] ??
            payload['schedule_date'] ??
            payload['scheduleDate'] ??
            payload['day'] ??
            payload['appointment_date'] ??
            payload['appointmentDate'],
      ),
      doctor: doctor,
      availableSlots: availableSlots,
      bookedSlots: bookedSlots,
    );
  }

  bool get hasAvailableSlots => availableSlots.isNotEmpty;

  static dynamic _unwrapPayload(Map<String, dynamic> response) {
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

    return response;
  }

  static DoctorModel? _extractDoctor(Map<String, dynamic> payload) {
    final doctorRaw = _mapFrom(payload, const [
      'doctor',
      'doctor_profile',
      'doctorProfile',
      'profile',
    ]);

    if (doctorRaw != null) {
      return DoctorModel.fromJson(doctorRaw);
    }

    if (payload.containsKey('full_name') ||
        payload.containsKey('fullName') ||
        payload.containsKey('name')) {
      return DoctorModel.fromJson(payload);
    }

    return null;
  }

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
        .toList();
  }

  static List<String> _normalizeAndSortSlots(
    List<String> slots, {
    List<String> fallback = const [],
  }) {
    final source = slots.isNotEmpty ? slots : fallback;
    final normalized = source
        .map(_normalizeTime)
        .where((slot) => slot.isNotEmpty)
        .toSet()
        .toList();

    normalized.sort(_compareTime);
    return normalized;
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

  static DateTime? _parseDate(dynamic value) {
    final raw = value?.toString().trim() ?? '';
    if (raw.isEmpty) return null;
    return DateTime.tryParse(raw);
  }
}