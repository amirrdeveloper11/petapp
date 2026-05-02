import 'package:flutter/material.dart';
import '../../../core/theme.dart';
import '../../homepage/models/product_model.dart';

class ProductDetailsInfo extends StatelessWidget {
  final ProductModel product;
  final String? categoryName;

  const ProductDetailsInfo({
    super.key,
    required this.product,
    required this.categoryName,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(28),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 18, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              product.name,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              '${product.price.toStringAsFixed(2)} ل.س',
              textDirection: TextDirection.rtl,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: AppColors.primaryGreenDark,
              ),
            ),
            const SizedBox(height: 14),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _InfoChip(
                  icon: Icons.inventory_2_rounded,
                  label: 'Stock: ${product.stock}',
                ),
                _InfoChip(
                  icon: Icons.category_rounded,
                  label: categoryName ?? 'Category ${product.categoryId}',
                ),
                if (product.isFeatured)
                  const _InfoChip(
                    icon: Icons.star_rounded,
                    label: 'Featured',
                  ),
              ],
            ),
            const SizedBox(height: 18),
            const Text(
              'Description',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              product.description.isEmpty
                  ? 'No description available for this product.'
                  : product.description,
              style: TextStyle(
                fontSize: 14,
                height: 1.6,
                color: AppColors.textSecondary.withOpacity(0.95),
              ),
            ),
            const SizedBox(height: 18),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.softBackground,
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Row(
                children: [
                  Icon(
                    Icons.local_shipping_rounded,
                    color: AppColors.primaryGreen,
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Fast delivery and secure checkout experience.',
                      style: TextStyle(
                        color: AppColors.textDark,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoChip({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: AppColors.inputStroke.withOpacity(0.22),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: AppColors.primaryGreenDark),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}