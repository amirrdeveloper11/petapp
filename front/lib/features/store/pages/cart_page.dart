import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:front/features/store/provider/cart_provider.dart';
import 'package:front/routes/app_routes.dart';

import '../../../widgets/app_empty_state.dart';
import '../../../widgets/app_confirm_dialog.dart';
import '../widgets/cart_item_card.dart';
import '../widgets/cart_summary_bar.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  Future<bool> _handleBack(BuildContext context) async {
    final cart = context.read<CartProvider>();

    if (cart.isEmpty) {
      return true;
    }

    final shouldLeave = await showAppConfirmDialog(
      context: context,
      title: 'Leave cart?',
      message: 'Your cart will be cleared if you go back.',
      cancelText: 'Cancel',
      confirmText: 'Leave',
      destructive: true,
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
        backgroundColor: const Color(0xFFF5F5F5),

        appBar: AppBar(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          elevation: 0,

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
            style: TextStyle(fontWeight: FontWeight.w800),
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

                    onIncrease: () {
                      context.read<CartProvider>().increase(item.product.id);
                    },

                    onDecrease: () {
                      context.read<CartProvider>().decrease(item.product.id);
                    },
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
