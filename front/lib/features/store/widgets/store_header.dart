import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme.dart';
import '../pages/cart_page.dart';
import '../provider/cart_provider.dart';

class StoreHeader extends StatelessWidget {
  final bool showBackButton;
  final VoidCallback? onBack;
  final VoidCallback? onCartTap;

  const StoreHeader({
    super.key,
    required this.showBackButton,
    this.onBack,
    this.onCartTap,
  });

  @override
  Widget build(BuildContext context) {
    final cartCount = context.watch<CartProvider>().totalItemsCount;

    return Row(
      children: [
        if (showBackButton)
          IconButton.filledTonal(
            onPressed: onBack ?? () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_rounded),
          ),
        if (showBackButton) const SizedBox(width: 12),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Store',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  height: 1.0,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Find what your pet needs',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        Badge(
          isLabelVisible: cartCount > 0,
          label: Text('$cartCount'),
          child: IconButton.filled(
            onPressed: onCartTap ??
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CartPage()),
                  );
                },
            icon: const Icon(Icons.shopping_bag_outlined),
          ),
        ),
      ],
    );
  }
}