import 'package:flutter/material.dart';
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
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.pets, color: Colors.green, size: 80),
                const SizedBox(height: 24),
                const Text(
                  "Create Account",
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 32),
                const RegisterForm(),
                const SizedBox(height: 24),
                const RegisterButton(),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () => Navigator.pushReplacementNamed(
                    context,
                    AppRoutes.loginScreen,
                  ),
                  child: const Text("Already have an account? Log in"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
