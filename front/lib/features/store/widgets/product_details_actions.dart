import 'package:flutter/material.dart';
import 'package:front/widgets/custom_button.dart';
import '../../../core/theme.dart';

class ProductDetailsActions extends StatelessWidget {
  final bool enabled;
  final VoidCallback onAddToCart;
  final double totalPrice;
  final bool isProcessing;

  const ProductDetailsActions({
    super.key,
    required this.enabled,
    required this.onAddToCart,
    required this.totalPrice,
    this.isProcessing = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 54,
            child: CustomButton(
              onPressed: enabled && !isProcessing ? onAddToCart : null,

              text: enabled ? 'Add to cart' : 'Out of stock',
            ),
          ),
        ),

        const SizedBox(width: 12),
        Container(
          height: 54,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.inputStroke.withOpacity(0.25)),
          ),
          alignment: Alignment.center,
          child: Text(
            '${totalPrice.toStringAsFixed(2)} ل.س',
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: AppColors.primaryGreenDark,
            ),
          ),
        ),
      ],
    );
  }
}
