import 'package:flutter/material.dart';
import 'package:front/core/theme.dart';
import 'package:front/features/order/model/order_model.dart';
import 'package:intl/intl.dart';

import 'package:front/widgets/app_card.dart';
import 'package:front/widgets/app_status_chip.dart';

class OrderCard extends StatelessWidget {
  final OrderModel order;
  final VoidCallback? onTap;

  const OrderCard({super.key, required this.order, this.onTap});

  @override
  Widget build(BuildContext context) {
    final currency = NumberFormat.currency(symbol: 'ل.س ', decimalDigits: 2);
    final dateFormat = DateFormat('MMM d, yyyy • h:mm a');

    return AppCard(
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppIconChip(icon: Icons.receipt_long_rounded, size: 52),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        order.orderNumber != null
                            ? 'Order #${order.orderNumber}'
                            : 'Order #${order.id ?? '-'}',
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 15,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    AppStatusChip(status: order.status, compact: true),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  dateFormat.format(order.createdAt ?? DateTime.now()),
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Text(
                      '${order.itemCount} items',
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      currency.format(order.effectiveTotal),
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: AppColors.deepTeal,
                      ),
                    ),
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
