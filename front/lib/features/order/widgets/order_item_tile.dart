import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:front/core/theme.dart';
import 'package:front/features/homepage/service/app_network_image.dart';

class OrderItemTile extends StatelessWidget {
  final String title;
  final String? imageUrl;
  final int quantity;
  final double unitPrice;
  final double totalPrice;
  final bool showDivider;

  const OrderItemTile({
    super.key,
    required this.title,
    required this.quantity,
    required this.unitPrice,
    required this.totalPrice,
    this.imageUrl,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    final image = imageUrl?.trim();
    final currency = NumberFormat.currency(symbol: 'ل.س ', decimalDigits: 2);

    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(AppRadii.md),
              child: SizedBox(
                width: 64,
                height: 64,
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
              child: Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        height: 1.25,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Qty $quantity • ${currency.format(unitPrice)}',
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              currency.format(totalPrice),
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: AppColors.deepTeal,
              ),
            ),
          ],
        ),
        if (showDivider) ...[
          const SizedBox(height: 14),
          const Divider(height: 1, color: AppColors.hairline),
        ],
      ],
    );
  }
}
