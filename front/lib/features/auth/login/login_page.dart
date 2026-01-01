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
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Branding section
                Column(
                  children: [
                    Container(
                      width: 84,
                      height: 84,
                      decoration: BoxDecoration(
                        color: AppColors.primaryGreen,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(
                        Icons.pets,
                        color: Colors.white,
                        size: 44,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'PetCo',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      "Your Pet's Best Friend",
                      style: TextStyle(fontSize: 15),
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                // Login Form
                const LoginForm(),
                const SizedBox(height: 24),

                // Login Button
                const LoginButton(),
                const SizedBox(height: 16),

                TextButton(
                  onPressed: () => Navigator.pushReplacementNamed(
                    context,
                    AppRoutes.registerScreen,
                  ),
                  child: const Text("Don’t have an account? Register"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
