import 'package:flutter/material.dart';
import 'package:front/core/theme.dart';

class BookingDateChip extends StatelessWidget {
  final DateTime date;
  final bool selected;
  final VoidCallback onTap;

  const BookingDateChip({
    super.key,
    required this.date,
    required this.selected,
    required this.onTap,
  });

  String _weekdayShort() {
    const names = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return names[date.weekday - 1];
  }

  String _monthShort() {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return months[date.month - 1];
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor = selected ? AppColors.deepTeal : AppColors.ivory;
    final borderColor = selected ? AppColors.deepTeal : AppColors.hairline;
    final foregroundColor = selected ? Colors.white : AppColors.textPrimary;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadii.md),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          width: 74,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(AppRadii.md),
            border: Border.all(color: borderColor),
            boxShadow: selected ? AppShadows.soft : null,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _weekdayShort(),
                style: TextStyle(
                  color: foregroundColor.withOpacity(0.82),
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${date.day}',
                style: TextStyle(
                  color: foregroundColor,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                _monthShort(),
                style: TextStyle(
                  color: foregroundColor.withOpacity(0.82),
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
