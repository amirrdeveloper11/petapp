import 'package:flutter/material.dart';
import 'package:front/core/theme.dart';
import 'package:front/features/homepage/models/product_model.dart';
import 'package:front/features/homepage/service/app_network_image.dart';

/// The single shared product card used on Home, Store grid and anywhere
/// else a product needs to be shown as a tile. Restyled to the ivory /
/// hairline / soft-shadow premium language, with a teal price accent and
/// a cleaner in-stock / out-of-stock treatment.
class AppProductCard extends StatelessWidget {
  final ProductModel product;
  final VoidCallback? onTap;

  const AppProductCard({super.key, required this.product, this.onTap});

  @override
  Widget build(BuildContext context) {
    final url = product.imageUrl?.trim();
    final inStock = product.stock > 0;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.ivory,
          borderRadius: BorderRadius.circular(AppRadii.xl),
          border: Border.all(color: AppColors.hairline, width: 1),
          boxShadow: AppShadows.card,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(AppRadii.lg),
                        child: Container(
                          color: AppColors.tealSoft,
                          child: Opacity(
                            opacity: inStock ? 1 : 0.45,
                            child: (url != null && url.isNotEmpty)
                                ? AppNetworkImage(
                                    url: url,
                                    fit: BoxFit.cover,
                                    errorWidget: const Center(
                                      child: Icon(
                                        Icons.image_not_supported_outlined,
                                        color: AppColors.teal,
                                      ),
                                    ),
                                  )
                                : const Center(
                                    child: Icon(
                                      Icons.image_not_supported_outlined,
                                      color: AppColors.teal,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 12,
                    top: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: (inStock ? AppColors.success : AppColors.danger)
                            .withOpacity(0.94),
                        borderRadius: BorderRadius.circular(AppRadii.pill),
                      ),
                      child: Text(
                        inStock ? 'In stock' : 'Out of stock',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10.5,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  if (product.isFeatured)
                    Positioned(
                      right: 12,
                      top: 12,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: AppColors.gold.withOpacity(0.95),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.star_rounded,
                          size: 13,
                          color: Colors.white,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 13.5,
                      height: 1.25,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    '${product.price.toStringAsFixed(2)} ل.س',
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 13.5,
                      color: AppColors.deepTeal,
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
