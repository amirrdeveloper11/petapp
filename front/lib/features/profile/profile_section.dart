import 'package:flutter/material.dart';
import 'package:front/core/theme.dart';
import 'package:front/features/homepage/widgets/home_quick_actions.dart';
import 'package:front/features/locations/pages/delivery_addresses_page.dart';
import 'package:front/features/petcrud/pet_list_screen.dart';
import 'package:front/features/profile/profilecrud/edit_profile_page.dart';
import 'package:front/features/profile/profilecrud/profile_hero_header.dart';
import 'package:front/features/profile/profilecrud/profile_menu_tile.dart';
import 'package:front/features/profile/profilecrud/profile_pets_section.dart';
import 'package:front/routes/app_routes.dart';
import 'package:front/widgets/app_card.dart';

class ProfileSection extends StatelessWidget {
  const ProfileSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.cream,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const ProfileHeroHeader(),
          Transform.translate(
            offset: const Offset(0, -24),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: HomeQuickActions(
                actions: [
                  QuickActionData(
                    icon: Icons.edit_rounded,
                    label: 'Edit Profile',
                    color: AppColors.deepTeal,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const EditProfilePage(),
                        ),
                      );
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
                    onTap: () =>
                        Navigator.pushNamed(context, AppRoutes.orderHistory),
                  ),
                  QuickActionData(
                    icon: Icons.location_on_rounded,
                    label: 'Addresses',
                    color: AppColors.gold,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const DeliveryAddressesPage(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
            child: Column(
              children: [
                const ProfilePetsSection(),
                const SizedBox(height: 16),
                const AppCard(
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                  child: ProfileMenuTile(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
