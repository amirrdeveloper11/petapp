import 'package:front/core/network/api_config.dart';
import 'package:front/core/network/api_response_parser.dart';
import 'package:front/core/network/base_api_service.dart';
import 'package:front/features/homepage/models/category_model.dart';
import 'package:front/features/homepage/models/product_model.dart';


class HomeService extends BaseApiService {
  Future<List<CategoryModel>> fetchCategories() async {
    final response = await getJson(ApiConfig.categories);
    final list = ApiResponseParser.list(
      response.data,
      keys: const ['data', 'categories', 'result'],
    );

    return list.map(CategoryModel.fromJson).toList();
  }

  Future<List<ProductModel>> fetchProducts() async {
    final response = await getJson(ApiConfig.products);
    final list = ApiResponseParser.list(
      response.data,
      keys: const ['data', 'products', 'result'],
    );

    return list.map(ProductModel.fromJson).toList();
  }
}