import 'package:flutter/material.dart';
import 'package:front/core/theme.dart';
import 'package:front/widgets/custom_button.dart';

class CartSummaryBar extends StatelessWidget {
  final double subtotal;
  final int itemCount;
  final VoidCallback onCheckout;

  final VoidCallback onAddMore;

  const CartSummaryBar({
    super.key,
    required this.subtotal,
    required this.itemCount,
    required this.onCheckout,
    required this.onAddMore,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 18,
            offset: const Offset(0, -4),
          ),
        ],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Subtotal • $itemCount items',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textSecondary,
                ),
              ),
              Text(
                '${subtotal.toStringAsFixed(2)} ل.س',
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primaryGreenDark,
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          Row(
            children: [
              Expanded(
                child: CustomButton(
                  text: 'Add more',
                  onPressed: onAddMore,
                  isPrimary: false,
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: CustomButton(
                  text: 'Checkout',
                  onPressed: onCheckout,
                  isPrimary: true,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
