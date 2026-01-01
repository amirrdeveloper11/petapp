import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:front/core/theme.dart';
import 'package:front/features/profile/profilecrud/edit_profile_page.dart';
import 'package:front/features/auth/user/provider/user_provider.dart';
import 'package:front/routes/app_routes.dart';

class ProfileMenuTile extends StatelessWidget {
  const ProfileMenuTile({super.key});

  void _deleteAccount(BuildContext context) {
    final provider = Provider.of<UserProvider>(context, listen: false);
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete Account'),
        content: const Text('Are you sure? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              await provider.deleteAccount();
              if (context.mounted) {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  AppRoutes.loginScreen,
                  (_) => false,
                );
              }
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<UserProvider>(context);

    return Column(
      children: [
        _menuTile(
          context,
          icon: Icons.edit,
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
          icon: Icons.logout,
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
          icon: Icons.delete,
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
      title: Text(label),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      tileColor: background,
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
    );
  }
}
