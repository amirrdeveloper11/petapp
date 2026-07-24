class WorkingHourModel {
  final String dayOfWeek;
  final String startTime;
  final String endTime;
  final String? notes;

  const WorkingHourModel({
    required this.dayOfWeek,
    required this.startTime,
    required this.endTime,
    this.notes,
  });

  factory WorkingHourModel.fromJson(Map<String, dynamic> json) {
    return WorkingHourModel(
      dayOfWeek: _toString(json['day_of_week'] ?? json['dayOfWeek']),
      startTime: _toString(json['start_time'] ?? json['startTime']),
      endTime: _toString(json['end_time'] ?? json['endTime']),
      notes: _toStringNullable(json['notes']),
    );
  }

  String get displayDay {
    final d = dayOfWeek.trim();
    if (d.isEmpty) return 'Day';
    final lowered = d.toLowerCase();
    return '${lowered[0].toUpperCase()}${lowered.substring(1)}';
  }

  List<String> get slots {
    try {
      final startParts = startTime.split(':');
      final endParts = endTime.split(':');
      if (startParts.length < 2 || endParts.length < 2) return const [];

      var startMinutes = int.parse(startParts[0]) * 60 + int.parse(startParts[1]);
      final endMinutes = int.parse(endParts[0]) * 60 + int.parse(endParts[1]);

      if (endMinutes <= startMinutes) return const [];

      final result = <String>[];
      while (startMinutes + 30 <= endMinutes) {
        final h = startMinutes ~/ 60;
        final m = startMinutes % 60;
        result.add('${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}');
        startMinutes += 30;
      }
      return result;
    } catch (_) {
      return const [];
    }
  }

  static String _toString(dynamic value) {
    final text = value?.toString().trim() ?? '';
    return text;
  }

  static String? _toStringNullable(dynamic value) {
    final text = value?.toString().trim() ?? '';
    return text.isEmpty ? null : text;
  }
}
