class DeliveryAddressModel {
  final int? id;
  final String deliveryAddress;
  final String city;
  final String area;
  final String contactPhone;
  final String? notes;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const DeliveryAddressModel({
    this.id,
    required this.deliveryAddress,
    required this.city,
    required this.area,
    required this.contactPhone,
    this.notes,
    this.createdAt,
    this.updatedAt,
  });

  factory DeliveryAddressModel.fromJson(Map<String, dynamic> json) {
    return DeliveryAddressModel(
      id: _toInt(json['id']),
      deliveryAddress: _toString(
        json['delivery_address'] ?? json['deliveryAddress'],
      ),
      city: _toString(json['city']),
      area: _toString(json['area']),
      contactPhone: _toString(
        json['contact_phone'] ?? json['contactPhone'],
      ),
      notes: _toStringNullable(json['notes']),
      createdAt: _toDateTime(json['created_at'] ?? json['createdAt']),
      updatedAt: _toDateTime(json['updated_at'] ?? json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'delivery_address': deliveryAddress.trim(),
      'city': city.trim(),
      'area': area.trim(),
      'contact_phone': contactPhone.trim(),
      'notes': _cleanNullable(notes),
    };
  }

  DeliveryAddressModel copyWith({
    int? id,
    String? deliveryAddress,
    String? city,
    String? area,
    String? contactPhone,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return DeliveryAddressModel(
      id: id ?? this.id,
      deliveryAddress: deliveryAddress ?? this.deliveryAddress,
      city: city ?? this.city,
      area: area ?? this.area,
      contactPhone: contactPhone ?? this.contactPhone,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  static int? _toInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is double) return value.toInt();
    return int.tryParse(value.toString());
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

  static String? _cleanNullable(String? value) {
    final text = value?.trim() ?? '';
    return text.isEmpty ? null : text;
  }
}