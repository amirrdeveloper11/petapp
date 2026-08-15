import 'package:flutter/material.dart';
import 'package:front/core/theme.dart';
import 'package:front/widgets/app_card.dart';

import '../models/doctor_model.dart';

class DoctorInfoCard extends StatelessWidget {
  final DoctorModel doctor;

  const DoctorInfoCard({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    final availabilityColor = doctor.isAvailable
        ? AppColors.success
        : AppColors.danger;

    return AppCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 66,
            height: 66,
            decoration: BoxDecoration(
              color: AppColors.tealSoft,
              borderRadius: BorderRadius.circular(AppRadii.lg),
            ),
            child: const Icon(
              Icons.medical_services_rounded,
              size: 30,
              color: AppColors.deepTeal,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        doctor.fullName,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                          letterSpacing: -0.2,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: availabilityColor.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(AppRadii.pill),
                      ),
                      child: Text(
                        doctor.isAvailable ? 'Available' : 'Busy',
                        style: TextStyle(
                          color: availabilityColor,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                if (doctor.specialty?.name != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    doctor.specialty!.name,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.teal,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
                const SizedBox(height: 8),
                Text(
                  '${doctor.consultationFee.toStringAsFixed(0)} ل.س',
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.deepTeal,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                if ((doctor.phone ?? '').trim().isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    doctor.phone!.trim(),
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary.withOpacity(0.9),
                    ),
                  ),
                ],
                if ((doctor.bio ?? '').trim().isNotEmpty) ...[
                  const SizedBox(height: 10),
                  Text(
                    doctor.bio!.trim(),
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary.withOpacity(0.95),
                      height: 1.5,
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
