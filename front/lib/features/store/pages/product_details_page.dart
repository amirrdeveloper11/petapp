import 'package:flutter/material.dart';
import 'package:front/core/theme.dart';
import 'package:front/features/homepage/models/product_model.dart';
import 'package:front/features/homepage/provider/wishlist_provider.dart';
import 'package:front/features/store/provider/cart_provider.dart';
import 'package:front/features/store/widgets/product_details_actions.dart';
import 'package:front/features/store/widgets/product_details_header.dart';
import 'package:front/features/store/widgets/product_details_info.dart';
import 'package:provider/provider.dart';

class ProductDetailsPage extends StatelessWidget {
  final ProductModel product;
  final String? categoryName;

  const ProductDetailsPage({
    super.key,
    required this.product,
    this.categoryName,
  });

  @override
  Widget build(BuildContext context) {
    final wishlist = context.watch<WishlistProvider>();
    final isWishlisted = wishlist.isInWishlist(product.id);

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 380,
            automaticallyImplyLeading: false,
            backgroundColor: AppColors.cream,
            surfaceTintColor: AppColors.cream,
            flexibleSpace: FlexibleSpaceBar(
              background: ProductDetailsHeader(
                product: product,
                isWishlisted: isWishlisted,
                onBack: () => Navigator.of(context).pop(),
                onWishlistToggle: () {
                  context.read<WishlistProvider>().toggle(product);
                },
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Transform.translate(
              offset: const Offset(0, -18),
              child: ProductDetailsInfo(
                product: product,
                categoryName: categoryName,
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: ProductDetailsActions(
            enabled: product.stock > 0,
            totalPrice: product.price,
            onAddToCart: () {
              context.read<CartProvider>().addProduct(product);
              Navigator.pop(context);
            },
          ),
        ),
      ),
    );
  }
}
