import 'package:flutter/material.dart';

import '../../homepage/models/product_model.dart';
import '../models/cart_item_model.dart';

class CartProvider extends ChangeNotifier {
  final Map<int, CartItemModel> _items = {};

  List<CartItemModel> get items => _items.values.toList();

  bool get isEmpty => _items.isEmpty;
  bool get isNotEmpty => _items.isNotEmpty;

  int get totalItemsCount =>
      _items.values.fold<int>(0, (sum, item) => sum + item.quantity);

  double get subTotal =>
      _items.values.fold<double>(0, (sum, item) => sum + item.totalPrice);

  void addProduct(ProductModel product, {int quantity = 1}) {
    if (quantity <= 0) return;

    final existing = _items[product.id];

    if (existing != null) {
      _updateQuantity(product.id, existing.quantity + quantity);
    } else {
      _items[product.id] = CartItemModel(
        product: product,
        quantity: _clamp(quantity, product.stock),
      );
      notifyListeners();
    }
  }

  void increase(int productId) {
    final item = _items[productId];
    if (item == null) return;

    _updateQuantity(productId, item.quantity + 1);
  }

  void decrease(int productId) {
    final item = _items[productId];
    if (item == null) return;

    if (item.quantity <= 1) {
      remove(productId);
    } else {
      _updateQuantity(productId, item.quantity - 1);
    }
  }

  void remove(int productId) {
    if (!_items.containsKey(productId)) return;

    _items.remove(productId);
    notifyListeners();
  }

  void clear() {
    if (_items.isEmpty) return;

    _items.clear();
    notifyListeners();
  }

  void _updateQuantity(int productId, int newQuantity) {
    final item = _items[productId];
    if (item == null) return;

    final clamped = _clamp(newQuantity, item.product.stock);

    if (clamped == item.quantity) return;

    item.quantity = clamped;
    notifyListeners();
  }

  int _clamp(int value, int max) {
    if (value < 1) return 1;
    if (value > max) return max;
    return value;
  }
}
