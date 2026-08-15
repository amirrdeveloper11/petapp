import 'package:flutter/material.dart';
import 'package:front/core/theme.dart';
import 'package:front/features/homepage/provider/wishlist_provider.dart';
import 'package:front/features/homepage/widgets/wishlist_item_card.dart';
import 'package:front/widgets/app_empty_state.dart';
import 'package:front/widgets/app_loading_states.dart';
import 'package:provider/provider.dart';

class WishlistPage extends StatelessWidget {
  const WishlistPage({super.key});

  @override
  Widget build(BuildContext context) {
    final wishlist = context.watch<WishlistProvider>();

    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        backgroundColor: AppColors.cream,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.deepTeal),
        title: const Text(
          'Wishlist',
          style: TextStyle(
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
      ),
      body: wishlist.isLoading
          ? const AppListShimmer()
          : wishlist.items.isEmpty
          ? const AppEmptyState(
              icon: Icons.favorite_border_rounded,
              title: 'Your wishlist is empty',
              subtitle: 'Tap the heart icon on any product to save it here.',
            )
          : ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              itemCount: wishlist.items.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final product = wishlist.items[index];
                return WishlistItemCard(product: product);
              },
            ),
    );
  }
}
