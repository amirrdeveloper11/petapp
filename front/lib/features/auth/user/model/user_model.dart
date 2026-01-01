class UserModel {
  final String id;
  final String fullName;
  final String email;

  UserModel({
    required this.id,
    required this.fullName,
    required this.email,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'].toString(),
      fullName: json['name'] ?? json['fullName'] ?? '',
      email: json['email'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': fullName,
        'email': email,
      };

  UserModel copyWith({
    String? fullName,
    String? email,
    String? imagePath,
  }) {
    return UserModel(
      id: id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
    );
  }
}
