import 'package:flutter/material.dart';
import '../models/category_model.dart';
import '../models/product_model.dart';
import '../service/home_service.dart';

class HomeProvider extends ChangeNotifier {
  final HomeService _homeService = HomeService();

  bool _isLoading = false;
  String? _errorMessage;

  List<CategoryModel> _categories = [];
  List<ProductModel> _products = [];

  int? _selectedCategoryId;
  String _searchQuery = '';

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<CategoryModel> get categories => _categories;
  List<ProductModel> get products => _products;
  int? get selectedCategoryId => _selectedCategoryId;
  String get searchQuery => _searchQuery;

  List<ProductModel> get featuredProducts {
    return _products.where((product) => product.isFeatured).toList();
  }

  Future<void> loadHomeData() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final results = await Future.wait([
        _homeService.fetchCategories(),
        _homeService.fetchProducts(),
      ]);

      _categories = results[0] as List<CategoryModel>;
      _products = results[1] as List<ProductModel>;

      if (_selectedCategoryId == null && _categories.isNotEmpty) {
        _selectedCategoryId = _categories.first.id;
      }
    } catch (e) {
      _errorMessage = e.toString();
      debugPrint('HomeProvider error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void selectCategory(int? categoryId) {
    _selectedCategoryId = _selectedCategoryId == categoryId ? null : categoryId;
    notifyListeners();
  }

  void updateSearchQuery(String value) {
    _searchQuery = value.trim().toLowerCase();
    notifyListeners();
  }

  bool _matchesSearch(ProductModel product) {
    if (_searchQuery.isEmpty) return true;

    return product.name.toLowerCase().contains(_searchQuery) ||
        product.description.toLowerCase().contains(_searchQuery);
  }

  bool _matchesCategory(ProductModel product) {
    return _selectedCategoryId == null ||
        product.categoryId == _selectedCategoryId;
  }

  List<ProductModel> get filteredProducts {
    return _products.where((product) {
      return _matchesCategory(product) && _matchesSearch(product);
    }).toList();
  }

  Future<void> refresh() async {
    await loadHomeData();
  }
}
