class PetModel {
  final int id;
  final String name;
  final String type;
  final String breed;
  final DateTime birthDate;
  final String gender;
  final double weight;
  final String? imagePath;

  PetModel({
    required this.id,
    required this.name,
    required this.type,
    required this.breed,
    required this.birthDate,
    required this.gender,
    required this.weight,
    this.imagePath,
  });

  factory PetModel.fromJson(Map<String, dynamic> json) {
    return PetModel(
      id: _toInt(json['id']),
      name: _toString(
        json['name'] ?? json['pet_name'] ?? json['title'],
        fallback: 'Pet',
      ),
      type: _toString(json['type'] ?? json['pet_type'], fallback: 'Unknown'),
      breed: _toString(json['breed'], fallback: 'Unknown'),
      birthDate:
          _toDateTime(json['birth_date'] ?? json['birthDate']) ??
          DateTime.now(),
      gender: _toString(json['gender'], fallback: 'unknown'),
      weight: _toDouble(json['weight']),
      imagePath: _toStringNullable(
        json['image_url'] ??
            json['imageUrl'] ??
            json['image_path'] ??
            json['imagePath'],
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'breed': breed,
      'birth_date': birthDate.toIso8601String(),
      'gender': gender.toLowerCase(),
      'weight': weight,
      'image_path': imagePath,
    };
  }

  int get age {
    final now = DateTime.now();
    int years = now.year - birthDate.year;
    if (now.month < birthDate.month ||
        (now.month == birthDate.month && now.day < birthDate.day)) {
      years--;
    }
    return years < 0 ? 0 : years;
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

  static DateTime? _toDateTime(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    return DateTime.tryParse(value.toString());
  }
}
