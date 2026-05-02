import 'package:flutter/material.dart';
import 'package:front/features/homepage/provider/wishlist_provider.dart';
import 'package:front/features/homepage/widgets/wishlist_item_card.dart';
import 'package:front/features/store/widgets/app_empty_state.dart';
import 'package:provider/provider.dart';

class WishlistPage extends StatelessWidget {
  const WishlistPage({super.key});

  @override
  Widget build(BuildContext context) {
    final wishlist = context.watch<WishlistProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Wishlist',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      body: wishlist.isLoading
          ? const Center(child: CircularProgressIndicator())
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
