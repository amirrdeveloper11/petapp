import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:front/features/homepage/models/product_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WishlistProvider extends ChangeNotifier {
  static const String _storageKey = 'wishlist_products';

  final List<ProductModel> _items = [];
  bool _isLoaded = false;
  bool _isLoading = false;

  List<ProductModel> get items => List.unmodifiable(_items);
  int get count => _items.length;
  bool get isLoaded => _isLoaded;
  bool get isLoading => _isLoading;

  Future<void> init() async {
    if (_isLoading || _isLoaded) return;
    _isLoading = true;
    notifyListeners();

    await _loadFromStorage();

    _isLoading = false;
    _isLoaded = true;
    notifyListeners();
  }

  bool isInWishlist(int productId) {
    return _items.any((item) => item.id == productId);
  }

  Future<void> toggle(ProductModel product) async {
    if (isInWishlist(product.id)) {
      await remove(product.id);
    } else {
      await add(product);
    }
  }

  Future<void> add(ProductModel product) async {
    if (isInWishlist(product.id)) return;

    _items.insert(0, product);
    notifyListeners();
    await _saveToStorage();
  }

  Future<void> remove(int productId) async {
    _items.removeWhere((item) => item.id == productId);
    notifyListeners();
    await _saveToStorage();
  }

  Future<void> clear() async {
    _items.clear();
    notifyListeners();
    await _saveToStorage();
  }

  Future<void> _loadFromStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final rawList = prefs.getStringList(_storageKey) ?? [];

      _items
        ..clear()
        ..addAll(
          rawList.map((raw) {
            final decoded = jsonDecode(raw);
            return ProductModel.fromJson(decoded);
          }),
        );
    } catch (e) {
      debugPrint('Wishlist load error: $e');
      _items.clear();
    }
  }

  Future<void> _saveToStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final rawList = _items.map((e) => jsonEncode(e.toJson())).toList();
      await prefs.setStringList(_storageKey, rawList);
    } catch (e) {
      debugPrint('Wishlist save error: $e');
    }
  }
}
