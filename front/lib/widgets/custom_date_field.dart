import 'package:flutter/material.dart';
import 'package:front/core/theme.dart';

class CustomDateField extends StatelessWidget {
  final String label;
  final DateTime? value;
  final VoidCallback onTap;

  const CustomDateField({
    super.key,
    required this.label,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.inputStroke),
          ),
          child: Row(
            children: [
              Icon(Icons.calendar_today, color: AppColors.primaryGreen),
              const SizedBox(width: 12),
              Text(
                value == null
                    ? label
                    : "${value!.day}/${value!.month}/${value!.year}",
                style: TextStyle(
                  fontSize: 15,
                  color: value == null ? AppColors.muted : AppColors.textPrimary,
                ),
              ),
              const Spacer(),
              const Icon(Icons.expand_more, color: Colors.black45),
            ],
          ),
        ),
      ),
    );
  }
}
