import 'package:flutter/material.dart';
import 'package:front/core/theme.dart';
import 'package:front/features/auth/login/provider/login_provider.dart';
import 'package:front/features/auth/login/widgets/login_button.dart';
import 'package:front/features/auth/login/widgets/login_form.dart';
import 'package:front/routes/app_routes.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LoginProvider(),
      child: Scaffold(
        backgroundColor: AppColors.cream,
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
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
                    const SizedBox(height: 16),
                    const Text(
                      'Pawpal',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                        letterSpacing: -0.4,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "Your Pet's Best Friend",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textSecondary.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                const LoginForm(),
                const SizedBox(height: 24),

                const LoginButton(),
                const SizedBox(height: 16),

                TextButton(
                  onPressed: () => Navigator.pushReplacementNamed(
                    context,
                    AppRoutes.registerScreen,
                  ),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.deepTeal,
                  ),
                  child: const Text(
                    "Don't have an account? Register",
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
