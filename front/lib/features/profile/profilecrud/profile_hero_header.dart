import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:front/core/theme.dart';
import 'package:front/features/auth/user/provider/user_provider.dart';
import 'package:front/features/profile/profilecrud/edit_profile_page.dart';

class ProfileHeroHeader extends StatelessWidget {
  const ProfileHeroHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().user;

    final fullName = (user?.fullName ?? '').trim();
    final email = (user?.email ?? '').trim();

    final displayName = fullName.isEmpty ? 'Pet Parent' : fullName;
    final initial = fullName.isEmpty ? 'W' : fullName[0].toUpperCase();

    void openEditProfile() {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const EditProfilePage()),
      );
    }

    return Container(
      color: AppColors.cream,
      child: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.bottomCenter,
            children: [_buildBanner(openEditProfile), _buildAvatar(initial)],
          ),
          const SizedBox(height: 60),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                Text(
                  displayName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                    letterSpacing: -0.2,
                  ),
                ),
                if (email.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    email,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary.withOpacity(0.9),
                    ),
                  ),
                ],
                const SizedBox(height: 50),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBanner(VoidCallback onTap) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(32),
        bottomRight: Radius.circular(32),
      ),
      child: Container(
        width: double.infinity,
        height: 132,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.goldLight, AppColors.gold],
          ),
        ),
        child: Stack(
          children: [
            Positioned(top: -30, left: -20, child: _buildBlob(120, 0.16)),
            Positioned(right: -30, bottom: -40, child: _buildBlob(140, 0.14)),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar(String initial) {
    return Positioned(
      bottom: -46,
      child: Container(
        width: 92,
        height: 92,
        padding: const EdgeInsets.all(4),
        decoration: const BoxDecoration(
          color: AppColors.cream,
          shape: BoxShape.circle,
        ),
        child: Container(
          decoration: const BoxDecoration(
            color: AppColors.deepTeal,
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Text(
            initial,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBlob(double size, double opacity) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withOpacity(opacity),
      ),
    );
  }
}
