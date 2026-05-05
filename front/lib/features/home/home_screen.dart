import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:front/features/store/sections/store_section.dart';
import 'package:front/features/homepage/home_page_section.dart';
import 'package:front/features/homepage/provider/home_provider.dart';
import 'package:front/features/profile/profile_section.dart';
import 'package:front/features/vet/vet_section.dart';
import 'package:front/routes/app_routes.dart';
import 'package:front/widgets/custom_bottom_navbar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  int? _storeCategoryId;
  String _storeSearch = '';

  void _changeTab(int index) {
    setState(() => _selectedIndex = index);
  }

  void _openStore({int? categoryId, String search = ''}) {
    setState(() {
      _storeCategoryId = categoryId;
      _storeSearch = search;
      _selectedIndex = 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    final homeProvider = context.watch<HomeProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      body: SafeArea(
        child: IndexedStack(
          index: _selectedIndex,
          children: [
            HomePageSection(onOpenStore: _openStore),
            StoreSection(
              products: homeProvider.products,
              categories: homeProvider.categories,
              initialCategoryId: _storeCategoryId,
              initialSearch: _storeSearch,
              showBackButton: false,
              onCartTap: () => Navigator.pushNamed(context, AppRoutes.cart),
            ),
            const VetSection(),
            const ProfileSection(),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: _selectedIndex,
        onTabChange: _changeTab,
      ),
    );
  }
}