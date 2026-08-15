import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:front/core/theme.dart';
import 'package:front/features/auth/user/provider/user_provider.dart';
import 'package:front/routes/app_routes.dart';
import 'package:front/widgets/app_confirm_dialog.dart';

class ProfileMenuTile extends StatelessWidget {
  const ProfileMenuTile({super.key});

  Future<void> _deleteAccount(BuildContext context) async {
    final confirmed = await showAppConfirmDialog(
      context: context,
      title: 'Delete account',
      message: 'Are you sure? This action cannot be undone.',
      confirmText: 'Delete',
      destructive: true,
    );

    if (!confirmed) return;

    final provider = Provider.of<UserProvider>(context, listen: false);

    try {
      await provider.deleteAccount();
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.toString())));
      }
      return;
    }

    if (context.mounted) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.loginScreen,
        (_) => false,
      );
    }
  }

  Future<void> _logout(BuildContext context) async {
    final confirmed = await showAppConfirmDialog(
      context: context,
      title: 'Log out',
      message: 'Are you sure you want to log out?',
      confirmText: 'Log out',
    );

    if (!confirmed) return;

    final provider = Provider.of<UserProvider>(context, listen: false);
    await provider.logout();

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
    return Column(
      children: [
        _menuTile(
          context,
          icon: Icons.calendar_month_rounded,
          label: 'My Appointments',
          color: AppColors.deepTeal,
          onTap: () =>
              Navigator.pushNamed(context, AppRoutes.appointmentHistory),
        ),
        const SizedBox(height: 10),
        _menuTile(
          context,
          icon: Icons.logout_rounded,
          label: 'Logout',
          color: AppColors.danger,
          onTap: () => _logout(context),
        ),
        const SizedBox(height: 10),
        _menuTile(
          context,
          icon: Icons.delete_rounded,
          label: 'Delete Account',
          color: AppColors.danger,
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
    required VoidCallback onTap,
  }) {
    return Material(
      color: color.withOpacity(0.08),
      borderRadius: BorderRadius.circular(AppRadii.md),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadii.md),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Icon(icon, color: color, size: 22),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14.5,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: AppColors.textSecondary.withOpacity(0.6),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
