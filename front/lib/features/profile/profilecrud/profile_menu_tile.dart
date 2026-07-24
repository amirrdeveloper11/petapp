import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:front/core/theme.dart';
import 'package:front/features/auth/user/provider/user_provider.dart';
import 'package:front/features/profile/profilecrud/edit_profile_page.dart';
import 'package:front/routes/app_routes.dart';
import 'package:front/widgets/app_confirm_dialog.dart';

class ProfileMenuTile extends StatelessWidget {
  const ProfileMenuTile({super.key});

  void _deleteAccount(BuildContext context) async {
    final confirmed = await showAppConfirmDialog(
      context: context,
      title: 'Delete account',
      message: 'Are you sure? This action cannot be undone.',
      confirmText: 'Delete',
      destructive: true,
    );

    if (!confirmed) return;

    final provider = Provider.of<UserProvider>(context, listen: false);
    await provider.deleteAccount();

    if (context.mounted) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.loginScreen,
        (_) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<UserProvider>(context);

    return Column(
      children: [
        _menuTile(
          context,
          icon: Icons.receipt_long_rounded,
          label: 'My Orders',
          color: AppColors.primaryGreen,
          background: AppColors.primaryGreenLight.withOpacity(0.16),
          onTap: () => Navigator.pushNamed(context, AppRoutes.orderHistory),
        ),
        const SizedBox(height: 12),
        _menuTile(
          context,
          icon: Icons.calendar_month_rounded,
          label: 'My Appointments',
          color: Colors.indigo,
          background: Colors.indigo.withOpacity(0.10),
          onTap: () =>
              Navigator.pushNamed(context, AppRoutes.appointmentHistory),
        ),
        const SizedBox(height: 12),
        _menuTile(
          context,
          icon: Icons.edit_rounded,
          label: 'Edit Profile',
          color: AppColors.primaryGreen,
          background: AppColors.primaryGreenLight.withOpacity(0.2),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const EditProfilePage()),
          ),
        ),
        const SizedBox(height: 12),
        _menuTile(
          context,
          icon: Icons.location_on_rounded,
          label: 'My Addresses',
          color: Colors.deepOrange,
          background: Colors.deepOrange.withOpacity(0.10),
          onTap: () =>
              Navigator.pushNamed(context, AppRoutes.deliveryAddresses),
        ),
        const SizedBox(height: 12),
        _menuTile(
          context,
          icon: Icons.logout_rounded,
          label: 'Logout',
          color: Colors.red,
          background: Colors.red.withOpacity(0.1),
          onTap: () async {
            await provider.logout();
            if (context.mounted) {
              Navigator.pushNamedAndRemoveUntil(
                context,
                AppRoutes.loginScreen,
                (_) => false,
              );
            }
          },
        ),
        const SizedBox(height: 12),
        _menuTile(
          context,
          icon: Icons.delete_rounded,
          label: 'Delete Account',
          color: Colors.red,
          background: Colors.red.withOpacity(0.1),
          onTap: () => _deleteAccount(context),
        ),
      ],
    );
  }

  Widget _menuTile(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required Color background,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(label, style: const TextStyle(fontWeight: FontWeight.w700)),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      tileColor: background,
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
    );
  }
}
