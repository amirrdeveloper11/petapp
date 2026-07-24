import 'package:flutter/material.dart';
import 'package:front/core/theme.dart';

import '../models/doctor_model.dart';

class DoctorInfoCard extends StatelessWidget {
  final DoctorModel doctor;

  const DoctorInfoCard({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final availabilityColor = doctor.isAvailable ? Colors.green : cs.error;

    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: AppColors.softBackground,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.medical_services_rounded,
                size: 30,
                color: AppColors.primaryGreenDark,
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
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: availabilityColor.withOpacity(0.10),
                          borderRadius: BorderRadius.circular(999),
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
                      style: TextStyle(
                        fontSize: 13,
                        color: cs.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                  const SizedBox(height: 8),
                  Text(
                    '${doctor.consultationFee.toStringAsFixed(0)} ل.س',
                    style: TextStyle(
                      fontSize: 14,
                      color: cs.onSurfaceVariant,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if ((doctor.phone ?? '').trim().isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      doctor.phone!.trim(),
                      style: TextStyle(
                        fontSize: 13,
                        color: cs.onSurfaceVariant,
                      ),
                    ),
                  ],
                  if ((doctor.bio ?? '').trim().isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(
                      doctor.bio!.trim(),
                      style: TextStyle(
                        fontSize: 13,
                        color: cs.onSurfaceVariant,
                        height: 1.45,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
