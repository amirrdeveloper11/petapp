import 'package:flutter/material.dart';
import 'package:front/features/homepage/models/product_model.dart';
import 'package:front/features/homepage/provider/wishlist_provider.dart';
import 'package:front/features/store/provider/cart_provider.dart';
import 'package:provider/provider.dart';

import '../provider/product_details_provider.dart';
import '../widgets/product_details_actions.dart';
import '../widgets/product_details_header.dart';
import '../widgets/product_details_info.dart';

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
    return ChangeNotifierProvider(
      create: (_) => ProductDetailsProvider(),
      child: _ProductDetailsView(
        product: product,
        categoryName: categoryName,
      ),
    );
  }
}

class _ProductDetailsView extends StatelessWidget {
  final ProductModel product;
  final String? categoryName;

  const _ProductDetailsView({
    required this.product,
    required this.categoryName,
  });

  @override
  Widget build(BuildContext context) {
    final details = context.watch<ProductDetailsProvider>();
    final wishlist = context.watch<WishlistProvider>();
    final isWishlisted = wishlist.isInWishlist(product.id);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 380,
            automaticallyImplyLeading: false,
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.white,
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
            totalPrice: product.price * details.quantity,
            onAddToCart: () {
              context.read<CartProvider>().addProduct(
                product,
                quantity: details.quantity,
              );
              Navigator.pop(context);
            },
          ),
        ),
      ),
    );
  }
}