import 'package:flutter/material.dart';
import 'package:front/core/theme.dart';
import 'package:front/features/auth/register/provider/register_provider.dart';
import 'package:provider/provider.dart';

class RegisterButton extends StatelessWidget {
  const RegisterButton({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<RegisterProvider>(context);

    return ElevatedButton(
      onPressed: provider.isLoading
          ? null
          : () => provider.submitRegister(context),
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
              "Register",
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
    );
  }
}
