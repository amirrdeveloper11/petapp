import 'package:flutter/material.dart';
import 'package:front/core/theme.dart';
import 'package:front/features/auth/login/provider/login_provider.dart';
import 'package:provider/provider.dart';

class LoginButton extends StatelessWidget {
  const LoginButton({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LoginProvider>(context);

    return ElevatedButton(
      onPressed: provider.isLoading
          ? null
          : () => provider.submitLogin(context),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryGreen,
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: provider.isLoading
          ? const CircularProgressIndicator(color: Colors.white)
          : const Text(
              "Login",
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
    );
  }
}
