import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'provider/home_provider.dart';
import 'widgets/home_banner_card.dart';
import 'widgets/home_categories_section.dart';
import 'widgets/home_featured_products_section.dart';
import 'widgets/home_search_bar.dart';
import 'widgets/home_shimmer.dart';
import 'widgets/home_top_header.dart';

class HomePageSection extends StatefulWidget {
  final void Function({int? categoryId, String search})? onOpenStore;

  const HomePageSection({
    super.key,
    this.onOpenStore,
  });

  @override
  State<HomePageSection> createState() => _HomePageSectionState();
}

class _HomePageSectionState extends State<HomePageSection> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeProvider>().loadHomeData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading &&
            provider.categories.isEmpty &&
            provider.products.isEmpty) {
          return const HomeShimmer();
        }

        return RefreshIndicator(
          onRefresh: provider.refresh,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
            children: [
              const HomeTopHeader(),
              const SizedBox(height: 20),
            HomeSearchBar(
  onTap: () {
    widget.onOpenStore?.call(search: '');
  },
),
              const SizedBox(height: 20),
              HomeCategoriesSection(
                categories: provider.categories,
                onSeeAll: () => widget.onOpenStore?.call(),
                onCategoryTap: (categoryId) {
                  provider.selectCategory(categoryId);
                  widget.onOpenStore?.call(categoryId: categoryId);
                },
              ),
              const SizedBox(height: 18),
              const HomeBannerCard(),
              const SizedBox(height: 18),
              HomeFeaturedProductsSection(
                products: provider.featuredProducts,
                categories: provider.categories,
                onSeeAll: () => widget.onOpenStore?.call(),
              ),
            ],
          ),
        );
      },
    );
  }
}