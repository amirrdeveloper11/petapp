import 'product_model.dart';

class CategoryModel {
  final int id;
  final String name;
  final String? imageUrl;
  final List<ProductModel> products;

  const CategoryModel({
    required this.id,
    required this.name,
    this.imageUrl,
    this.products = const [],
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id'].toString()) ?? 0,
      name: json['name']?.toString() ?? '',
      imageUrl: json['image_url']?.toString(),
      products: (json['products'] as List? ?? [])
          .map((e) => ProductModel.fromJson(Map<String, dynamic>.from(e)))
          .toList(),
    );
  }
}
