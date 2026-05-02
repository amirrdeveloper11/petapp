import '../../../core/services/network.dart';
import '../models/category_model.dart';
import '../models/product_model.dart';

class HomeService {
  Future<List<CategoryModel>> fetchCategories() async {
    final response = await AppDio.dio.get('/categories');
    return _parseList(response.data).map(CategoryModel.fromJson).toList();
  }

  Future<List<ProductModel>> fetchProducts() async {
    final response = await AppDio.dio.get('/products');
    return _parseList(response.data).map(ProductModel.fromJson).toList();
  }

  List<Map<String, dynamic>> _parseList(dynamic data) {
    if (data is Map<String, dynamic> && data['data'] is List) {
      return List<Map<String, dynamic>>.from(data['data']);
    }

    if (data is List) {
      return List<Map<String, dynamic>>.from(data);
    }

    throw Exception('Invalid API response format');
  }
}
