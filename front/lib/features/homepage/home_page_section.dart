import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:front/core/theme.dart';
import 'package:front/features/petcrud/pet_list_screen.dart';
import 'package:front/features/vet/providers/appointment_provider.dart';
import 'package:front/routes/app_routes.dart';

import 'provider/home_provider.dart';
import 'widgets/home_banner_card.dart';
import 'widgets/home_categories_section.dart';
import 'widgets/home_featured_products_section.dart';
import 'widgets/home_hero_header.dart';
import 'widgets/home_quick_actions.dart';
import 'widgets/home_search_bar.dart';
import 'widgets/home_shimmer.dart';

class HomePageSection extends StatefulWidget {
  final void Function({int? categoryId, String search})? onOpenStore;
  final void Function(int index)? onSwitchTab;

  const HomePageSection({super.key, this.onOpenStore, this.onSwitchTab});

  @override
  State<HomePageSection> createState() => _HomePageSectionState();
}

class _HomePageSectionState extends State<HomePageSection> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<HomeProvider>().loadHomeData();
      context.read<AppointmentProvider>().refresh();
    });
  }

  void _goToVetTab() {
    widget.onSwitchTab?.call(2);
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

        return Container(
          color: AppColors.cream,
          child: RefreshIndicator(
            color: AppColors.teal,
            onRefresh: () async {
              await Future.wait([
                provider.refresh(),
                context.read<AppointmentProvider>().refresh(),
              ]);
            },
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              children: [
                const HomeHeroHeader(),
                Transform.translate(
                  offset: const Offset(0, -24),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: HomeSearchBar(
                      onTap: () {
                        widget.onOpenStore?.call(search: '');
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 2),
                      HomeQuickActions(
                        actions: [
                          QuickActionData(
                            icon: Icons.medical_services_rounded,
                            label: 'Book a Vet',
                            color: AppColors.teal,
                            onTap: _goToVetTab,
                          ),
                          QuickActionData(
                            icon: Icons.storefront_rounded,
                            label: 'Pet Store',
                            color: AppColors.gold,
                            onTap: () {
                              widget.onOpenStore?.call();
                            },
                          ),
                          QuickActionData(
                            icon: Icons.pets_rounded,
                            label: 'My Pets',
                            color: AppColors.primaryGreenDark,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const PetListScreen(),
                                ),
                              );
                            },
                          ),
                          QuickActionData(
                            icon: Icons.receipt_long_rounded,
                            label: 'My Orders',
                            color: AppColors.secondaryOrange,
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                AppRoutes.orderHistory,
                              );
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 26),
                      HomeCategoriesSection(
                        categories: provider.categories,
                        onSeeAll: () {
                          widget.onOpenStore?.call();
                        },
                        onCategoryTap: (categoryId) {
                          provider.selectCategory(categoryId);
                          widget.onOpenStore?.call(categoryId: categoryId);
                        },
                      ),
                      const SizedBox(height: 24),
                      const HomeBannerCard(),
                      const SizedBox(height: 28),
                      HomeFeaturedProductsSection(
                        products: provider.featuredProducts,
                        categories: provider.categories,
                        onSeeAll: () {
                          widget.onOpenStore?.call();
                        },
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
