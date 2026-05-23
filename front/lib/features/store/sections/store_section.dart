import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../homepage/models/category_model.dart';
import '../../homepage/models/product_model.dart';
import '../pages/product_details_page.dart';
import '../provider/store_provider.dart';
import '../../../widgets/app_empty_state.dart';
import '../widgets/store_category_chips.dart';
import '../widgets/store_header.dart';
import '../widgets/store_product_grid.dart';
import '../widgets/store_search_bar.dart';

class StoreSection extends StatefulWidget {
  final List<ProductModel> products;
  final List<CategoryModel> categories;
  final int? initialCategoryId;
  final String initialSearch;
  final bool showBackButton;
  final VoidCallback? onBack;
  final VoidCallback? onCartTap;

  const StoreSection({
    super.key,
    required this.products,
    required this.categories,
    this.initialCategoryId,
    this.initialSearch = '',
    required this.showBackButton,
    this.onBack,
    this.onCartTap,
  });

  @override
  State<StoreSection> createState() => _StoreSectionState();
}

class _StoreSectionState extends State<StoreSection> {
  late final StoreProvider _provider;

  @override
  void initState() {
    super.initState();
    _provider = StoreProvider()
      ..setData(
        products: widget.products,
        categoryId: widget.initialCategoryId,
        search: widget.initialSearch,
      );
  }

  @override
  void didUpdateWidget(covariant StoreSection oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.initialCategoryId != widget.initialCategoryId ||
        oldWidget.initialSearch != widget.initialSearch ||
        oldWidget.products != widget.products) {
      _provider.setData(
        products: widget.products,
        categoryId: widget.initialCategoryId,
        search: widget.initialSearch,
      );
    }
  }

  @override
  void dispose() {
    _provider.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _provider,
      child: _StoreView(
        categories: widget.categories,
        showBackButton: widget.showBackButton,
        onBack: widget.onBack,
        onCartTap: widget.onCartTap,
      ),
    );
  }
}

class _StoreView extends StatelessWidget {
  final List<CategoryModel> categories;
  final bool showBackButton;
  final VoidCallback? onBack;
  final VoidCallback? onCartTap;

  const _StoreView({
    required this.categories,
    required this.showBackButton,
    required this.onBack,
    required this.onCartTap,
  });

  String? _categoryNameFor(int categoryId) {
    for (final category in categories) {
      if (category.id == categoryId) return category.name;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<StoreProvider>();
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: cs.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
          child: Column(
            children: [
              StoreHeader(
                showBackButton: showBackButton,
                onBack: onBack,
                onCartTap: onCartTap,
              ),
              const SizedBox(height: 14),
              StoreSearchBar(onChanged: provider.updateSearch),
              const SizedBox(height: 14),
              StoreCategoryChips(
                categories: categories,
                selectedCategoryId: provider.selectedCategoryId,
                onSelected: provider.toggleCategory,
              ),
              const SizedBox(height: 14),
              Expanded(
                child: provider.filteredProducts.isEmpty
                    ? const AppEmptyState(
                        icon: Icons.shopping_bag_outlined,
                        title: 'No products found',
                        subtitle: 'Try another category or search keyword.',
                      )
                    : StoreProductGrid(
                        products: provider.filteredProducts,
                        onProductTap: (product) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ProductDetailsPage(
                                product: product,
                                categoryName: _categoryNameFor(
                                  product.categoryId,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
