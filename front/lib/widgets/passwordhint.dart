import 'package:flutter/material.dart';
import 'package:front/core/theme.dart';

class PasswordHints extends StatelessWidget {
  final TextEditingController controller;
  final TextEditingController? confirmController;

  const PasswordHints({
    super.key,
    required this.controller,
    this.confirmController,
  });

  bool get hasMinLength => controller.text.length >= 6;
  bool get hasNumber => RegExp(r'\d').hasMatch(controller.text);
  bool get hasSpecial =>
      RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(controller.text);

  bool get passwordsMatch {
    if (confirmController == null) return true;
    return controller.text.isNotEmpty &&
        controller.text == confirmController!.text;
  }

  Widget _hint(bool valid, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Icon(
            valid ? Icons.check_circle_rounded : Icons.circle_outlined,
            size: 14,
            color: valid ? AppColors.success : AppColors.muted,
          ),
          const SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
              color: valid ? AppColors.success : AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([
        controller,
        if (confirmController != null) confirmController!,
      ]),
      builder: (_, __) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _hint(hasMinLength, 'At least 6 characters'),
            _hint(hasNumber, 'Contains a number'),
            _hint(hasSpecial, 'Contains a special character'),
            if (confirmController != null)
              _hint(passwordsMatch, 'Passwords match'),
          ],
        );
      },
    );
  }
}
