import 'package:front/features/store/models/cart_item_model.dart';

class OrderItemModel {
  final int? id;
  final int productId;
  final String productName;
  final String? imageUrl;
  final double unitPrice;
  final int quantity;

  const OrderItemModel({
    this.id,
    required this.productId,
    required this.productName,
    this.imageUrl,
    required this.unitPrice,
    required this.quantity,
  });

  double get totalPrice => unitPrice * quantity;

  factory OrderItemModel.fromCartItem(CartItemModel cartItem) {
    final product = cartItem.product;

    return OrderItemModel(
      productId: product.id,
      productName: product.name,
      imageUrl: product.imageUrl,
      unitPrice: product.price,
      quantity: cartItem.quantity,
    );
  }

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    final product = _asMap(json['product']);

    return OrderItemModel(
      id: _toIntNullable(json['id']),
      productId: _toInt(
        json['product_id'] ??
            json['productId'] ??
            product?['id'] ??
            0,
      ),
      productName: _toString(
        product?['name'] ??
            json['product_name'] ??
            json['name'] ??
            json['title'] ??
            'Item',
      ),
      imageUrl: _toStringNullable(
        product?['image'] ??
            product?['image_url'] ??
            json['image'] ??
            json['image_url'],
      ),
      unitPrice: _toDouble(
        json['unit_price'] ??
            json['price'] ??
            json['product_price'] ??
            product?['price'] ??
            0,
      ),
      quantity: _toInt(json['quantity'] ?? 1),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product_id': productId,
      'product_name': productName,
      'image_url': imageUrl,
      'unit_price': unitPrice,
      'quantity': quantity,
      'total_price': totalPrice,
    };
  }

  static Map<String, dynamic>? _asMap(dynamic value) {
    if (value is Map<String, dynamic>) return value;
    return null;
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

  static String _toString(dynamic value) {
    final text = value?.toString().trim() ?? '';
    return text.isEmpty ? 'Item' : text;
  }

  static String? _toStringNullable(dynamic value) {
    final text = value?.toString().trim() ?? '';
    return text.isEmpty ? null : text;
  }
}