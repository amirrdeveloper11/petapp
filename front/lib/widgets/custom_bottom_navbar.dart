import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import '../core/theme.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTabChange;

  const CustomBottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onTabChange,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: SafeArea(
        child: GNav(
          gap: 8,
          backgroundColor: Colors.white,
          color: Colors.grey[600],
          activeColor: AppColors.primaryGreen,
          tabBackgroundColor: AppColors.primaryGreen.withOpacity(0.15),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          selectedIndex: selectedIndex,
          onTabChange: onTabChange,
          tabs: const [
            GButton(icon: Icons.storefront_outlined, text: 'Store'),
            GButton(icon: Icons.health_and_safety, text: 'Vet'),
            GButton(icon: Icons.person_outline, text: 'Profile'),
          ],
        ),
      ),
    );
  }
}
