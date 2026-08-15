import 'package:flutter/material.dart';

import '../../../core/theme.dart';
import '../../../widgets/app_card.dart';
import '../../homepage/service/app_network_image.dart';
import '../models/cart_item_model.dart';
import 'product_quantity.dart';

class CartItemCard extends StatelessWidget {
  final CartItemModel item;
  final VoidCallback onIncrease;
  final VoidCallback onDecrease;

  const CartItemCard({
    super.key,
    required this.item,
    required this.onIncrease,
    required this.onDecrease,
  });

  @override
  Widget build(BuildContext context) {
    final canIncrease = item.quantity < item.product.stock;
    final image = item.product.imageUrl?.trim();

    return AppCard(
      padding: const EdgeInsets.all(12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadii.lg),
            child: SizedBox(
              width: 84,
              height: 84,
              child: image != null && image.isNotEmpty
                  ? AppNetworkImage(
                      url: image,
                      fit: BoxFit.cover,
                      errorWidget: Container(
                        color: AppColors.tealSoft,
                        child: const Icon(
                          Icons.image_not_supported_outlined,
                          color: AppColors.teal,
                        ),
                      ),
                    )
                  : Container(
                      color: AppColors.tealSoft,
                      child: const Icon(
                        Icons.image_not_supported_outlined,
                        color: AppColors.teal,
                      ),
                    ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.product.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    height: 1.2,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '${item.product.price.toStringAsFixed(2)} ل.س',
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    color: AppColors.deepTeal,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    ProductQuantityStepper(
                      quantity: item.quantity,
                      onIncrease: onIncrease,
                      onDecrease: onDecrease,
                      canIncrease: canIncrease,
                    ),
                    const Spacer(),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
