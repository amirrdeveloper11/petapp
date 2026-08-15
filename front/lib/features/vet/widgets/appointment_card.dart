import 'package:flutter/material.dart';
import 'package:front/core/theme.dart';
import 'package:front/widgets/app_card.dart';
import 'package:front/widgets/app_status_chip.dart';

import '../models/appointment_model.dart';

class AppointmentCard extends StatelessWidget {
  final AppointmentModel appointment;
  final VoidCallback? onTap;

  const AppointmentCard({super.key, required this.appointment, this.onTap});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppIconChip(icon: Icons.medical_services_rounded, size: 52),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        appointment.doctor?.fullName ?? 'Doctor',
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 15,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    AppStatusChip(
                      status: appointment.displayStatus,
                      compact: true,
                    ),
                  ],
                ),
                if (appointment.doctor?.specialtyName != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    appointment.doctor!.specialtyName!,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.teal,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
                const SizedBox(height: 8),
                Wrap(
                  spacing: 12,
                  runSpacing: 4,
                  children: [
                    _Meta(
                      icon: Icons.calendar_today_rounded,
                      text: appointment.appointmentDate,
                    ),
                    _Meta(
                      icon: Icons.access_time_rounded,
                      text: appointment.appointmentTime,
                    ),
                    if (appointment.pet != null)
                      _Meta(
                        icon: Icons.pets_rounded,
                        text: appointment.pet!.name,
                      ),
                  ],
                ),
                if (onTap != null) ...[
                  const SizedBox(height: 8),
                  const Text(
                    'Tap to view details',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.teal,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Meta extends StatelessWidget {
  final IconData icon;
  final String text;

  const _Meta({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13, color: AppColors.textSecondary),
        const SizedBox(width: 4),
        Text(
          text,
          style: const TextStyle(
            fontSize: 13,
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
