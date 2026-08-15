import 'package:flutter/material.dart';
import 'package:front/core/theme.dart';

/// Shared text field used across auth, checkout, and profile forms.
/// Restyled to the ivory / hairline / deep-teal focus language while
/// keeping the exact same public API as before.
class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadii.md),
        boxShadow: AppShadows.soft,
      ),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(
            vertical: 18,
            horizontal: 16,
          ),
          prefixIcon: prefixIcon != null
              ? Icon(prefixIcon, color: AppColors.deepTeal)
              : null,
          suffixIcon: suffixIcon,
          hintText: hintText,
          hintStyle: TextStyle(
            color: AppColors.textSecondary.withOpacity(0.85),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          filled: true,
          fillColor: AppColors.ivory,
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: AppColors.hairline),
            borderRadius: BorderRadius.circular(AppRadii.md),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: AppColors.deepTeal, width: 1.5),
            borderRadius: BorderRadius.circular(AppRadii.md),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.danger.withOpacity(0.6)),
            borderRadius: BorderRadius.circular(AppRadii.md),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: AppColors.danger, width: 1.5),
            borderRadius: BorderRadius.circular(AppRadii.md),
          ),
        ),
        validator: validator,
      ),
    );
  }
}
