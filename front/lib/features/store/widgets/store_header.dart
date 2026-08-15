import 'package:flutter/material.dart';
import 'package:front/core/theme.dart';
import 'package:front/features/store/provider/cart_provider.dart';
import 'package:front/routes/app_routes.dart';
import 'package:front/widgets/app_section_header.dart';
import 'package:provider/provider.dart';

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

    return AppPageHeader(
      title: 'Store',
      subtitle: 'Find what your pet needs',
      showBackButton: showBackButton,
      onBack: onBack,
      trailing: _CartButton(
        count: cartCount,
        onTap: onCartTap ?? () => Navigator.pushNamed(context, AppRoutes.cart),
      ),
    );
  }
}

class _CartButton extends StatelessWidget {
  final int count;
  final VoidCallback onTap;

  const _CartButton({required this.count, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 58,
        height: 58,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: 58,
              height: 58,
              decoration: BoxDecoration(
                color: AppColors.deepTeal,
                shape: BoxShape.circle,
                boxShadow: AppShadows.soft,
              ),
              child: const Icon(
                Icons.shopping_bag_outlined,
                color: Colors.white,
                size: 24,
              ),
            ),
            if (count > 0)
              Positioned(
                right: -2,
                top: -2,
                child: Container(
                  height: 21,
                  width: 21,
                  decoration: BoxDecoration(
                    color: AppColors.gold,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.cream, width: 2),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    count > 9 ? '9+' : '$count',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
