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
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      decoration: BoxDecoration(
        color: AppColors.ivory,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(28),
        ),
        border: const Border(
          top: BorderSide(color: AppColors.hairline, width: 1),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.deepTeal.withOpacity(0.12),
            blurRadius: 24,
            offset: const Offset(0, -6),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: GNav(
          gap: 8,
          curve: Curves.easeOutCubic,
          duration: const Duration(milliseconds: 320),
          backgroundColor: AppColors.ivory,
          color: AppColors.textSecondary,
          activeColor: AppColors.deepTeal,
          iconSize: 22,
          tabBackgroundColor: AppColors.tealSoft,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          selectedIndex: selectedIndex,
          onTabChange: onTabChange,
          textStyle: const TextStyle(
            color: AppColors.deepTeal,
            fontWeight: FontWeight.w700,
            fontSize: 13,
          ),
          tabs: const [
            GButton(icon: Icons.home_rounded, text: 'Home'),
            GButton(icon: Icons.storefront_rounded, text: 'Store'),
            GButton(icon: Icons.health_and_safety_rounded, text: 'Vet'),
            GButton(icon: Icons.person_rounded, text: 'Profile'),
          ],
        ),
      ),
    );
  }
}
