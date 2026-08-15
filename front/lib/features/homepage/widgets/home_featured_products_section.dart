import 'package:flutter/material.dart';
import '../../homepage/models/category_model.dart';
import '../../homepage/models/product_model.dart';
import '../widgets/home_product_card.dart';
import '../widgets/home_section_header.dart';

class HomeFeaturedProductsSection extends StatelessWidget {
  final List<ProductModel> products;
  final List<CategoryModel> categories;
  final VoidCallback onSeeAll;

  const HomeFeaturedProductsSection({
    super.key,
    required this.products,
    required this.categories,
    required this.onSeeAll,
  });

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HomeSectionHeader(
          title: 'Recommended for You',
          subtitle: 'Picked from our most-loved products',
          leadingIcon: Icons.auto_awesome_rounded,
          onActionTap: onSeeAll,
        ),
        const SizedBox(height: 14),
        SizedBox(
          height: 270,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: products.length,
            separatorBuilder: (_, __) => const SizedBox(width: 14),
            itemBuilder: (_, index) {
              final product = products[index];

              return SizedBox(
                width: 172,
                child: HomeProductCard(
                  product: product,
                  categories: categories,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
