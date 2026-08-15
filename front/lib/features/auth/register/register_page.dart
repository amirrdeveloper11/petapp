import 'package:flutter/material.dart';
import 'package:front/core/theme.dart';
import 'package:front/features/auth/register/provider/register_provider.dart';
import 'package:front/features/auth/register/widgets/register_form.dart';
import 'package:front/features/auth/register/widgets/register_button.dart';
import 'package:front/routes/app_routes.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => RegisterProvider(),
      child: Scaffold(
        backgroundColor: AppColors.cream,
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 84,
                  height: 84,
                  decoration: BoxDecoration(
                    color: AppColors.tealSoft,
                    borderRadius: BorderRadius.circular(AppRadii.xl),
                    border: Border.all(color: AppColors.hairline),
                  ),
                  child: const Icon(
                    Icons.pets_rounded,
                    color: AppColors.deepTeal,
                    size: 40,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Create Account',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 28),
                const RegisterForm(),
                const SizedBox(height: 24),
                const RegisterButton(),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () => Navigator.pushReplacementNamed(
                    context,
                    AppRoutes.loginScreen,
                  ),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.deepTeal,
                  ),
                  child: const Text(
                    'Already have an account? Log in',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
