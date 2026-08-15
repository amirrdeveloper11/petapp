import 'package:flutter/material.dart';
import '../../../core/theme.dart';
import '../../homepage/models/product_model.dart';
import '../../homepage/service/app_network_image.dart';

class ProductDetailsHeader extends StatelessWidget {
  final ProductModel product;
  final bool isWishlisted;
  final VoidCallback onBack;
  final VoidCallback onWishlistToggle;

  const ProductDetailsHeader({
    super.key,
    required this.product,
    required this.isWishlisted,
    required this.onBack,
    required this.onWishlistToggle,
  });

  @override
  Widget build(BuildContext context) {
    final url = product.imageUrl?.trim();

    return SizedBox(
      height: 380,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Container(color: AppColors.tealSoft),
          if (url != null && url.isNotEmpty)
            Hero(
              tag: 'product-image-${product.id}',
              child: AppNetworkImage(
                url: url,
                fit: BoxFit.cover,
                errorWidget: const Center(
                  child: Icon(
                    Icons.image_not_supported_outlined,
                    size: 42,
                    color: AppColors.teal,
                  ),
                ),
              ),
            )
          else
            const Center(
              child: Icon(
                Icons.image_not_supported_outlined,
                size: 42,
                color: AppColors.teal,
              ),
            ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.deepTeal.withOpacity(0.04),
                  AppColors.deepTeal.withOpacity(0.32),
                ],
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).padding.top + 12,
            left: 16,
            child: _CircleButton(
              icon: Icons.arrow_back_ios_new_rounded,
              onTap: onBack,
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).padding.top + 12,
            right: 16,
            child: _CircleButton(
              icon: isWishlisted
                  ? Icons.favorite_rounded
                  : Icons.favorite_border_rounded,
              onTap: onWishlistToggle,
              iconColor: isWishlisted ? AppColors.danger : AppColors.deepTeal,
            ),
          ),
          Positioned(
            left: 16,
            right: 16,
            bottom: 16,
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                if (product.isFeatured)
                  _Badge(
                    icon: Icons.star_rounded,
                    label: 'Featured',
                    background: AppColors.gold,
                  ),
                _Badge(
                  icon: product.stock > 0
                      ? Icons.check_circle_rounded
                      : Icons.cancel_rounded,
                  label: product.stock > 0 ? 'In stock' : 'Out of stock',
                  background: product.stock > 0
                      ? AppColors.success
                      : AppColors.danger,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CircleButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color? iconColor;

  const _CircleButton({
    required this.icon,
    required this.onTap,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.ivory.withOpacity(0.96),
      shape: const CircleBorder(),
      elevation: 3,
      shadowColor: AppColors.deepTeal.withOpacity(0.2),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(
          width: 44,
          height: 44,
          child: Icon(
            icon,
            size: 20,
            color: iconColor ?? AppColors.deepTeal,
          ),
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color background;

  const _Badge({
    required this.icon,
    required this.label,
    required this.background,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(
        color: background.withOpacity(0.95),
        borderRadius: BorderRadius.circular(AppRadii.pill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.white),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
