import 'package:flutter/material.dart';
import 'package:front/core/theme.dart';
import '../models/working_hour_model.dart';

class WorkingScheduleTile extends StatelessWidget {
  final WorkingHourModel hour;

  const WorkingScheduleTile({super.key, required this.hour});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.softBackground,
        borderRadius: BorderRadius.circular(16),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Wrap(
            runSpacing: 6,
            spacing: 10,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              SizedBox(
                width: 90,
                child: Text(
                  hour.displayDay,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                    color: AppColors.textDark,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const Icon(
                Icons.schedule_rounded,
                size: 14,
                color: AppColors.primaryGreenDark,
              ),
              Text(
                '${hour.startTime} - ${hour.endTime}',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (hour.notes != null && hour.notes!.isNotEmpty)
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: constraints.maxWidth * 0.6,
                  ),
                  child: Text(
                    hour.notes!,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
