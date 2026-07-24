import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/doctor_booking_provider.dart';
import '../widgets/doctor_booking_form.dart';
import '../widgets/doctor_info_card.dart';
import '../widgets/section_title.dart';
import '../widgets/working_schedule_tile.dart';

class DoctorDetailsPage extends StatelessWidget {
  final int doctorId;

  const DoctorDetailsPage({super.key, required this.doctorId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DoctorBookingProvider()..loadDoctor(doctorId),
      child: const _DoctorDetailsBody(),
    );
  }
}

class _DoctorDetailsBody extends StatelessWidget {
  const _DoctorDetailsBody();

  @override
  Widget build(BuildContext context) {
    return Consumer<DoctorBookingProvider>(
      builder: (context, p, _) {
        final doctor = p.doctor;

        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'Doctor Details',
              style: TextStyle(fontWeight: FontWeight.w800),
            ),
            surfaceTintColor: Colors.transparent,
          ),
          body: p.loading && doctor == null
              ? const Center(child: CircularProgressIndicator())
              : doctor == null
                  ? _ErrorState(message: p.error ?? 'Doctor not found')
                  : ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                      children: [
                        DoctorInfoCard(doctor: doctor),
                        const SizedBox(height: 20),
                        const SectionTitle(
                          title: 'Working Schedule',
                          subtitle: 'Choose a day that matches the schedule',
                        ),
                        const SizedBox(height: 12),
                        if (doctor.workingHours.isEmpty)
                          const _Hint(text: 'No working hours available')
                        else
                          ...doctor.workingHours.map(
                            (hour) => WorkingScheduleTile(hour: hour),
                          ),
                        const SizedBox(height: 20),
                        const DoctorBookingForm(),
                      ],
                    ),
        );
      },
    );
  }
}

class _Hint extends StatelessWidget {
  final String text;

  const _Hint({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.35),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text(text),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String message;

  const _ErrorState({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
        ),
      ),
    );
  }
}
