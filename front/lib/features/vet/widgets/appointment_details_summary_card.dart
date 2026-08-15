import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:front/core/theme.dart';
import 'package:front/widgets/app_card.dart';
import 'package:front/widgets/app_labeled_value.dart';
import 'package:front/widgets/app_status_chip.dart';

import '../models/appointment_model.dart';

class AppointmentDetailsSummaryCard extends StatelessWidget {
  final AppointmentModel appointment;

  const AppointmentDetailsSummaryCard({super.key, required this.appointment});

  @override
  Widget build(BuildContext context) {
    final currency = NumberFormat.currency(symbol: 'ل.س ', decimalDigits: 0);
    final createdAt = appointment.createdAt;
    final dateFormat = DateFormat('EEEE, MMM d, yyyy');

    return AppCard(
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Appointment #${appointment.id}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              AppStatusChip(status: appointment.displayStatus),
            ],
          ),
          const SizedBox(height: 14),
          AppLabeledValue(label: 'Date', value: appointment.appointmentDate),
          AppLabeledValue(label: 'Time', value: appointment.appointmentTime),
          if (appointment.pet != null) ...[
            AppLabeledValue(label: 'Pet', value: appointment.pet!.name),
          ],
          if (appointment.doctor != null) ...[
            AppLabeledValue(
              label: 'Doctor',
              value: appointment.doctor!.fullName,
            ),
            AppLabeledValue(
              label: 'Fee',
              value: currency.format(appointment.doctor!.consultationFee),
            ),
            if ((appointment.doctor!.specialtyName ?? '').trim().isNotEmpty)
              AppLabeledValue(
                label: 'Specialty',
                value: appointment.doctor!.specialtyName!.trim(),
              ),
          ],
          if ((appointment.reason ?? '').trim().isNotEmpty)
            AppLabeledValue(
              label: 'Reason',
              value: appointment.reason!.trim(),
              valueBold: false,
            ),
          if ((appointment.consultationNotes ?? '').trim().isNotEmpty)
            AppLabeledValue(
              label: 'Notes',
              value: appointment.consultationNotes!.trim(),
              valueBold: false,
            ),
          if ((appointment.rejectionReason ?? '').trim().isNotEmpty)
            AppLabeledValue(
              label: 'Rejection reason',
              value: appointment.rejectionReason!.trim(),
              valueBold: false,
            ),
          if (createdAt != null) ...[
            const SizedBox(height: 8),
            Text(
              'Booked on ${dateFormat.format(createdAt)}',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.textSecondary.withOpacity(0.9),
                fontSize: 12.5,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
