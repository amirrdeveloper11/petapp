import 'package:flutter/material.dart';
import 'package:front/core/theme.dart';
import 'package:front/features/homepage/models/product_model.dart';
import 'package:front/features/homepage/service/app_network_image.dart';

class AppProductCard extends StatelessWidget {
  final ProductModel product;
  final VoidCallback? onTap;

  const AppProductCard({
    super.key,
    required this.product,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final url = product.imageUrl?.trim();

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowLight,
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: (url != null && url.isNotEmpty)
                          ? AppNetworkImage(
                              url: url,
                              fit: BoxFit.cover,
                              errorWidget: const Center(
                                child: Icon(Icons.image_not_supported_outlined),
                              ),
                            )
                          : const Center(
                              child: Icon(Icons.image_not_supported_outlined),
                            ),
                    ),
                  ),
                  if (product.stock > 0)
                    Positioned(
                      left: 12,
                      top: 12,
                      child: _Badge(
                        text: 'In stock',
                        color: Colors.green,
                      ),
                    )
                  else
                    Positioned(
                      left: 12,
                      top: 12,
                      child: _Badge(
                        text: 'Out',
                        color: Colors.red,
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
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${product.price.toStringAsFixed(2)} ل.س',
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      color: AppColors.primaryGreenDark,
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

class _Badge extends StatelessWidget {
  final String text;
  final Color color;

  const _Badge({
    required this.text,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.92),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}