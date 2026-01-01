class PetModel {
  final String id;
  final String name;
  final String type;
  final String breed;
  final DateTime birthDate;
  final String gender;
  final double weight;
  final String? imagePath;
  final String? notes;

  PetModel({
    required this.id,
    required this.name,
    required this.type,
    required this.breed,
    required this.birthDate,
    required this.gender,
    required this.weight,
    this.imagePath,
    this.notes,
  });

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
