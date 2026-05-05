import 'package:front/features/homepage/models/product_model.dart';

class CartItemModel {
  final ProductModel product;
  int quantity;

  CartItemModel({required this.product, required this.quantity});

  double get totalPrice => product.price * quantity;
}
