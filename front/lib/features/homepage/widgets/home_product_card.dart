import 'package:flutter/material.dart';
import 'package:front/features/homepage/models/category_model.dart';
import 'package:front/features/store/pages/product_details_page.dart';
import 'package:front/widgets/app_product_card.dart';
import '../models/product_model.dart';

class HomeProductCard extends StatelessWidget {
  final ProductModel product;
  final List<CategoryModel>? categories; 

  const HomeProductCard({super.key, required this.product, this.categories});

  String? _categoryName() {
    if (categories == null) return null;
    for (final cat in categories!) {
      if (cat.id == product.categoryId) return cat.name;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return AppProductCard(
      product: product,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ProductDetailsPage(
              product: product,
              categoryName: _categoryName(),
            ),
          ),
        );
      },
      
    );
  }
}
