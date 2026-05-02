import 'package:flutter/material.dart';

import '../../homepage/models/category_model.dart';
import '../../homepage/models/product_model.dart';
import '../sections/store_section.dart';

class StorePage extends StatelessWidget {
  final List<ProductModel> products;
  final List<CategoryModel> categories;
  final int? initialCategoryId;
  final String initialSearch;

  const StorePage({
    super.key,
    required this.products,
    required this.categories,
    this.initialCategoryId,
    this.initialSearch = '',
  });

  @override
  Widget build(BuildContext context) {
    return StoreSection(
      products: products,
      categories: categories,
      initialCategoryId: initialCategoryId,
      initialSearch: initialSearch,
      showBackButton: Navigator.of(context).canPop(),
    );
  }
}