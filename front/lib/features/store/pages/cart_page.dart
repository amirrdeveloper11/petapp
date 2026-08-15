import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:front/core/theme.dart';
import 'package:front/features/store/provider/cart_provider.dart';
import 'package:front/routes/app_routes.dart';
import '../../../widgets/app_empty_state.dart';
import '../widgets/cart_item_card.dart';
import '../widgets/cart_summary_bar.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  Future<bool> _showConfirmDialog({
    required BuildContext context,
    required String title,
    required String message,
    required String confirmText,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: AppColors.ivory,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadii.lg),
          ),
          title: Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          content: Text(
            message,
            style: const TextStyle(color: AppColors.textSecondary),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text(
                'Cancel',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.danger,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadii.sm),
                ),
              ),
              child: Text(
                confirmText,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          ],
        );
      },
    );

    return result ?? false;
  }

  Future<bool> _handleBack(BuildContext context) async {
    final cart = context.read<CartProvider>();

    if (cart.isEmpty) return true;

    final shouldLeave = await _showConfirmDialog(
      context: context,
      title: 'Leave cart?',
      message: 'Your cart will be cleared if you go back.',
      confirmText: 'Leave',
    );

    if (shouldLeave) {
      cart.clear();
    }

    return shouldLeave;
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();

    return WillPopScope(
      onWillPop: () => _handleBack(context),
      child: Scaffold(
        backgroundColor: AppColors.cream,
        appBar: AppBar(
          backgroundColor: AppColors.cream,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          iconTheme: const IconThemeData(color: AppColors.deepTeal),
          leading: IconButton(
            onPressed: () async {
              final shouldPop = await _handleBack(context);
              if (shouldPop && context.mounted) {
                Navigator.pop(context);
              }
            },
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
          ),
          title: const Text(
            'Cart',
            style: TextStyle(
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        body: cart.isEmpty
            ? const AppEmptyState(
                icon: Icons.shopping_cart_outlined,
                title: 'Your cart is empty',
                subtitle: 'Add products from the store to continue.',
              )
            : ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
                itemCount: cart.items.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final item = cart.items[index];

                  return CartItemCard(
                    item: item,
                    onIncrease: () =>
                        context.read<CartProvider>().increase(item.product.id),
                    onDecrease: () =>
                        context.read<CartProvider>().decrease(item.product.id),
                  );
                },
              ),
        bottomNavigationBar: cart.isEmpty
            ? null
            : SafeArea(
                top: false,
                child: CartSummaryBar(
                  subtotal: cart.subTotal,
                  itemCount: cart.totalItemsCount,
                  onCheckout: () {
                    Navigator.pushNamed(context, AppRoutes.orderCheckout);
                  },
                  onAddMore: () {
                    Navigator.pop(context);
                  },
                ),
              ),
      ),
    );
  }
}
