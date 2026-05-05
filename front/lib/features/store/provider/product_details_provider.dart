import 'package:flutter/material.dart';

class ProductDetailsProvider extends ChangeNotifier {
  int _quantity = 1;

  int get quantity => _quantity;

  void increase({required int maxStock}) {
    if (_quantity >= maxStock) return;
    _quantity++;
    notifyListeners();
  }

  void decrease() {
    if (_quantity <= 1) return;
    _quantity--;
    notifyListeners();
  }
}
