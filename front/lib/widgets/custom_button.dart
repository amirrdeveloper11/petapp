import 'package:flutter/material.dart';
import 'package:front/core/theme.dart';

/// Primary/secondary action button used everywhere in the app (auth, vet
/// booking, cart, checkout...). Restyled to the deep-teal / ivory premium
/// palette while keeping the exact same public API so every existing call
/// site keeps working unchanged.
class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isPrimary;
  final bool isLoading;
  final IconData? icon;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isPrimary = true,
    this.isLoading = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final buttonChild = isLoading
        ? SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                isPrimary ? Colors.white : AppColors.deepTeal,
              ),
            ),
          )
        : Text(
            text,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          );

    if (!isPrimary) {
      return SizedBox(
        width: double.infinity,
        height: 54,
        child: OutlinedButton.icon(
          onPressed: isLoading ? null : onPressed,
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.deepTeal,
            disabledForegroundColor: AppColors.deepTeal.withOpacity(0.4),
            backgroundColor: AppColors.tealSoft,
            side: BorderSide(color: AppColors.deepTeal.withOpacity(0.18)),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadii.md),
            ),
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          icon: icon == null || isLoading
              ? const SizedBox.shrink()
              : Icon(icon, size: 20),
          label: buttonChild,
        ),
      );
    }

    return SizedBox(
      width: double.infinity,
      height: 54,
      child: icon != null
          ? FilledButton.icon(
              onPressed: isLoading ? null : onPressed,
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.deepTeal,
                foregroundColor: Colors.white,
                disabledBackgroundColor: AppColors.deepTeal.withOpacity(0.4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadii.md),
                ),
                elevation: 0,
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              icon: isLoading ? const SizedBox.shrink() : Icon(icon, size: 20),
              label: buttonChild,
            )
          : FilledButton(
              onPressed: isLoading ? null : onPressed,
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.deepTeal,
                foregroundColor: Colors.white,
                disabledBackgroundColor: AppColors.deepTeal.withOpacity(0.4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadii.md),
                ),
                elevation: 0,
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              child: buttonChild,
            ),
    );
  }
}
