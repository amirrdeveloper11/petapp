import 'package:flutter/material.dart';
import 'package:front/core/theme.dart';
import '../../homepage/models/category_model.dart';
import '../../homepage/models/product_model.dart';
import '../widgets/home_product_card.dart';

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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Featured Products',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
            ),
            InkWell(
              onTap: onSeeAll,
              child: const Padding(
                padding: EdgeInsets.all(4),
                child: Text(
                  'See all',
                  style: TextStyle(
                    color: AppColors.primaryGreen,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 270,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: products.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (_, index) {
              final product = products[index];

              return SizedBox(
                width: 170,
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
