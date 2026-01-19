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
      id: json['id'],
      name: json['name'],
      type: json['type'],
      breed: json['breed'],
      birthDate: DateTime.parse(json['birth_date']),
      gender: json['gender'],
      weight: double.tryParse(json['weight'].toString()) ?? 0,
      imagePath: json['image_path'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
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
    return years;
  }
}
