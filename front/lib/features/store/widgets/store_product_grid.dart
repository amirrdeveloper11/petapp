import 'package:flutter/material.dart';
import 'package:front/widgets/app_product_card.dart';

import '../../homepage/models/product_model.dart';

class StoreProductGrid extends StatelessWidget {
  final List<ProductModel> products;
  final ValueChanged<ProductModel> onProductTap;

  const StoreProductGrid({
    super.key,
    required this.products,
    required this.onProductTap,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.only(bottom: 12),
      itemCount: products.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.76,
      ),
      itemBuilder: (context, index) {
        final product = products[index];
        return AppProductCard(
          product: product,
          onTap: () => onProductTap(product),
        );
      },
    );
  }
}