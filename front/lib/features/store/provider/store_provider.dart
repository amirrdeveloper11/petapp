import 'package:flutter/material.dart';
import 'package:front/features/homepage/models/product_model.dart';

class StoreProvider extends ChangeNotifier {
  List<ProductModel> _allProducts = [];
  int? _selectedCategoryId;
  String _searchQuery = '';

  List<ProductModel> get allProducts => _allProducts;
  int? get selectedCategoryId => _selectedCategoryId;
  String get searchQuery => _searchQuery;

  void setData({
    required List<ProductModel> products,
    int? categoryId,
    String search = '',
  }) {
    _allProducts = products;
    _selectedCategoryId = categoryId;
    _searchQuery = search.trim().toLowerCase();
    notifyListeners();
  }

  void toggleCategory(int categoryId) {
    _selectedCategoryId = _selectedCategoryId == categoryId ? null : categoryId;
    notifyListeners();
  }

  void updateSearch(String value) {
    _searchQuery = value.trim().toLowerCase();
    notifyListeners();
  }

  bool _matchesCategory(ProductModel product) {
    return _selectedCategoryId == null ||
        product.categoryId == _selectedCategoryId;
  }

  bool _matchesSearch(ProductModel product) {
    if (_searchQuery.isEmpty) return true;

    return product.name.toLowerCase().contains(_searchQuery) ||
        product.description.toLowerCase().contains(_searchQuery);
  }

  List<ProductModel> get filteredProducts {
    return _allProducts.where((product) {
      return _matchesCategory(product) && _matchesSearch(product);
    }).toList();
  }
}
