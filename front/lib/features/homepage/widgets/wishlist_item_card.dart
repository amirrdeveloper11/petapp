
import 'package:flutter/material.dart';
import 'package:front/core/theme.dart';
import 'package:front/features/homepage/models/product_model.dart';
import 'package:front/features/homepage/provider/wishlist_provider.dart';
import 'package:front/features/homepage/service/app_network_image.dart';
import 'package:front/features/store/provider/cart_provider.dart';
import 'package:front/widgets/custom_button.dart';
import 'package:provider/provider.dart';

class WishlistItemCard extends StatelessWidget {
  final ProductModel product;

  const WishlistItemCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final wishlist = context.read<WishlistProvider>();
    final cart = context.read<CartProvider>();
    final image = product.imageUrl?.trim();
    final canAddToCart = product.stock > 0;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: SizedBox(
              width: 84,
              height: 84,
              child: image != null && image.isNotEmpty
                  ? AppNetworkImage(
                      url: image,
                      fit: BoxFit.cover,
                      errorWidget: Container(
                        color: AppColors.softBackground,
                        child: const Icon(Icons.image_not_supported_outlined),
                      ),
                    )
                  : Container(
                      color: AppColors.softBackground,
                      child: const Icon(Icons.image_not_supported_outlined),
                    ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        product.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          height: 1.2,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => wishlist.remove(product.id),
                      icon: const Icon(Icons.close_rounded),
                      visualDensity: VisualDensity.compact,
                      color: AppColors.textSecondary,
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  '${product.price.toStringAsFixed(2)} ل.س',
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    color: AppColors.primaryGreenDark,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  product.stock > 0 ? 'In stock' : 'Out of stock',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: product.stock > 0 ? Colors.green : Colors.red,
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  height: 44,
                  child: CustomButton(
                    text: canAddToCart ? 'Add to cart' : 'Out of stock',
                    onPressed: canAddToCart
                        ? () {
                            cart.addProduct(product);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Added to cart'),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          }
                        : null,
                    isPrimary: true,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
