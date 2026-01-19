import 'package:flutter/material.dart';
import 'package:front/core/theme.dart';
import 'package:front/features/auth/login/provider/login_provider.dart';
import 'package:front/widgets/custom_text_field.dart';
import 'package:provider/provider.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LoginProvider>(context);

    return Form(
      key: provider.formKey,
      child: Column(
        children: [
          CustomTextField(
            controller: provider.emailController,
            hintText: 'Email',
            prefixIcon: Icons.mail_outline,
            keyboardType: TextInputType.emailAddress,
            validator: (v) {
              if (v == null || v.isEmpty) return 'Please enter email';
              if (!RegExp(r'^[\w-.]+@([\w-]+\.)+[\w]{2,4}$').hasMatch(v.trim())) {
                return 'Invalid email';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          CustomTextField(
            controller: provider.passwordController,
            hintText: 'Password',
            prefixIcon: Icons.lock_outline,
            obscureText: !provider.isPasswordVisible,
            suffixIcon: IconButton(
              icon: Icon(
                provider.isPasswordVisible
                    ? Icons.visibility_off
                    : Icons.visibility,
                color: AppColors.primaryGreen,
              ),
              onPressed: provider.togglePasswordVisibility,
            ),
            validator: (v) =>
                v == null || v.length < 6 ? 'Minimum 6 characters' : null,
          ),

          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
