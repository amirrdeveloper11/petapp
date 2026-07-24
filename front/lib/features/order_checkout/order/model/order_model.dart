import 'order_item_model.dart';
import 'payment_method.dart';

class OrderModel {
  final int? id;
  final String? orderNumber;
  final String status;
  final PaymentMethodType paymentMethod;
  final double subtotal;
  final double tax;
  final double deliveryFee;
  final double total;
  final String? deliveryAddress;
  final String? city;
  final String? area;
  final String? contactPhone;
  final String? paymentReference;
  final String? notes;
  final bool? canCancelFlag;
  final DateTime? placedAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<OrderItemModel> items;

  const OrderModel({
    this.id,
    this.orderNumber,
    required this.status,
    required this.paymentMethod,
    required this.subtotal,
    this.tax = 0,
    this.deliveryFee = 0,
    required this.total,
    this.deliveryAddress,
    this.city,
    this.area,
    this.contactPhone,
    this.paymentReference,
    this.notes,
    this.canCancelFlag,
    this.placedAt,
    this.createdAt,
    this.updatedAt,
    required this.items,
  });

  bool get canCancel => canCancelFlag ?? status.trim().toLowerCase() == 'pending';

  int get itemCount => items.fold<int>(0, (sum, item) => sum + item.quantity);

  double get effectiveTotal => total;

  String? get note => notes;

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    final itemsJson = _extractList(json, const ['items', 'order_items', 'details', 'products']);
    final items = itemsJson
        .map((e) => OrderItemModel.fromJson(_asMap(e) ?? <String, dynamic>{}))
        .toList();

    final payment = paymentMethodFromJson(
      _toStringNullable(
        json['payment_method'] ?? json['paymentMethod'] ?? json['payment_type'],
      ),
    );

    return OrderModel(
      id: _toIntNullable(json['id']),
      orderNumber: _toStringNullable(
        json['order_number'] ?? json['orderNo'] ?? json['number'] ?? json['code'],
      ),
      status: _toString(json['status'] ?? 'pending'),
      paymentMethod: payment,
      subtotal: _toDouble(json['subtotal'] ?? json['sub_total'] ?? 0),
      tax: _toDouble(json['tax'] ?? 0),
      deliveryFee: _toDouble(json['delivery_fee'] ?? json['deliveryFee'] ?? 0),
      total: _toDouble(
        json['total'] ?? json['grand_total'] ?? json['amount'] ?? json['subtotal'] ?? 0,
      ),
      deliveryAddress: _toStringNullable(json['delivery_address'] ?? json['address']),
      city: _toStringNullable(json['city']),
      area: _toStringNullable(json['area']),
      contactPhone: _toStringNullable(json['contact_phone'] ?? json['phone']),
      paymentReference: _toStringNullable(json['payment_reference']),
      notes: _toStringNullable(json['notes'] ?? json['note'] ?? json['customer_note'] ?? json['remarks']),
      canCancelFlag: _toBoolNullable(json['can_cancel']),
      placedAt: _toDateTimeNullable(json['placed_at'] ?? json['created_at'] ?? json['createdAt'] ?? json['date']),
      createdAt: _toDateTimeNullable(json['created_at'] ?? json['createdAt'] ?? json['date']),
      updatedAt: _toDateTimeNullable(json['updated_at'] ?? json['updatedAt']),
      items: items,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_number': orderNumber,
      'status': status,
      'payment_method': paymentMethod.apiValue,
      'subtotal': subtotal,
      'tax': tax,
      'delivery_fee': deliveryFee,
      'total': total,
      'delivery_address': deliveryAddress,
      'city': city,
      'area': area,
      'contact_phone': contactPhone,
      'payment_reference': paymentReference,
      'notes': notes,
      'placed_at': placedAt?.toIso8601String(),
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'items': items.map((item) => item.toJson()).toList(),
    };
  }

  OrderModel copyWith({
    int? id,
    String? orderNumber,
    String? status,
    PaymentMethodType? paymentMethod,
    double? subtotal,
    double? tax,
    double? deliveryFee,
    double? total,
    String? deliveryAddress,
    String? city,
    String? area,
    String? contactPhone,
    String? paymentReference,
    String? notes,
    bool? canCancelFlag,
    DateTime? placedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<OrderItemModel>? items,
  }) {
    return OrderModel(
      id: id ?? this.id,
      orderNumber: orderNumber ?? this.orderNumber,
      status: status ?? this.status,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      subtotal: subtotal ?? this.subtotal,
      tax: tax ?? this.tax,
      deliveryFee: deliveryFee ?? this.deliveryFee,
      total: total ?? this.total,
      deliveryAddress: deliveryAddress ?? this.deliveryAddress,
      city: city ?? this.city,
      area: area ?? this.area,
      contactPhone: contactPhone ?? this.contactPhone,
      paymentReference: paymentReference ?? this.paymentReference,
      notes: notes ?? this.notes,
      canCancelFlag: canCancelFlag ?? this.canCancelFlag,
      placedAt: placedAt ?? this.placedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      items: items ?? this.items,
    );
  }

  static Map<String, dynamic>? _asMap(dynamic value) {
    if (value is Map<String, dynamic>) return value;
    return null;
  }

  static List<dynamic> _extractList(
    Map<String, dynamic> json,
    List<String> keys,
  ) {
    for (final key in keys) {
      final value = json[key];
      if (value is List) return value;
      if (value is Map<String, dynamic>) {
        final nested = value['data'];
        if (nested is List) return nested;
      }
    }

    final data = json['data'];
    if (data is List) return data;
    if (data is Map<String, dynamic>) {
      final nested = data['items'] ?? data['order_items'];
      if (nested is List) return nested;
    }

    return const [];
  }

  static int _toInt(dynamic value) {
    if (value is int) return value;
    if (value is double) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  static int? _toIntNullable(dynamic value) {
    if (value == null) return null;
    final parsed = _toInt(value);
    return parsed == 0 ? null : parsed;
  }

  static double _toDouble(dynamic value) {
    if (value is double) return value;
    if (value is int) return value.toDouble();
    return double.tryParse(value?.toString() ?? '') ?? 0;
  }

  static bool? _toBoolNullable(dynamic value) {
    if (value == null) return null;
    if (value is bool) return value;
    final text = value.toString().trim().toLowerCase();
    if (text.isEmpty) return null;
    if (text == '1' || text == 'true' || text == 'yes') return true;
    if (text == '0' || text == 'false' || text == 'no') return false;
    return null;
  }

  static String _toString(dynamic value) {
    final text = value?.toString().trim() ?? '';
    return text.isEmpty ? 'Unknown' : text;
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
}
