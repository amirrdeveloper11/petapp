class SpecialtyModel {
  final int id;
  final String name;
  final String? description;

  const SpecialtyModel({
    required this.id,
    required this.name,
    this.description,
  });

  factory SpecialtyModel.fromJson(Map<String, dynamic> json) {
    return SpecialtyModel(
      id: _toInt(json['id']),
      name: _toString(
        json['name'] ?? json['specialty_name'] ?? json['title'],
        fallback: 'Specialty',
      ),
      description: _toStringNullable(json['description']),
    );
  }

  static int _toInt(dynamic value) {
    if (value is int) return value;
    if (value is double) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? 0;
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
