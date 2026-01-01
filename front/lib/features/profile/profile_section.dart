import 'package:flutter/material.dart';
import 'package:front/core/theme.dart';
import 'package:front/features/profile/profilecrud/profile_menu_tile.dart';
import 'package:front/features/profile/profilecrud/profile_header.dart';
import 'package:front/features/profile/profilecrud/profile_pets_section.dart';

class ProfileSection extends StatelessWidget {
  const ProfileSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.softBackground,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Profile Card
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            elevation: 6,
            shadowColor: AppColors.primaryGreen.withOpacity(0.3),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: const ProfileHeader(),
            ),
          ),
          const SizedBox(height: 24),
          // Menu
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            elevation: 4,
            shadowColor: AppColors.primaryGreen.withOpacity(0.2),
            child: const Padding(
              padding: EdgeInsets.all(16),
              child: ProfileMenuTile(),
            ),
          ),
          const ProfilePetsSection(),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
