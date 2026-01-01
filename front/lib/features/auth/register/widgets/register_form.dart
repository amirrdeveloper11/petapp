import 'package:flutter/material.dart';
import 'package:front/core/theme.dart';
import 'package:front/features/auth/register/provider/register_provider.dart';
import 'package:front/widgets/custom_text_field.dart';
import 'package:front/widgets/passwordhint.dart';
import 'package:provider/provider.dart';

class RegisterForm extends StatelessWidget {
  const RegisterForm({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<RegisterProvider>();

    return Form(
      key: provider.formKey,
      child: Column(
        children: [
          CustomTextField(
            controller: provider.fullNameController,
            hintText: 'Full Name',
            prefixIcon: Icons.person_outline,
            validator: (v) =>
                v == null || v.isEmpty ? 'Please enter your name' : null,
          ),
          const SizedBox(height: 16),

          CustomTextField(
            controller: provider.emailController,
            hintText: 'Email',
            prefixIcon: Icons.mail_outline,
            keyboardType: TextInputType.emailAddress,
            validator: (v) {
              if (v == null || v.isEmpty) return 'Please enter email';
              if (!RegExp(
                r'^[\w-.]+@([\w-]+\.)+[\w]{2,4}$',
              ).hasMatch(v.trim())) {
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
          ),
          const SizedBox(height: 8),

          PasswordHints(
            controller: provider.passwordController,
            confirmController: provider.confirmPasswordController,
          ),

          const SizedBox(height: 16),

          CustomTextField(
            controller: provider.confirmPasswordController,
            hintText: 'Confirm Password',
            prefixIcon: Icons.lock,
            obscureText: !provider.isConfirmPasswordVisible,
            suffixIcon: IconButton(
              icon: Icon(
                provider.isConfirmPasswordVisible
                    ? Icons.visibility_off
                    : Icons.visibility,
                color: AppColors.primaryGreen,
              ),
              onPressed: provider.toggleConfirmPasswordVisibility,
            ),
          ),
        ],
      ),
    );
  }
}
