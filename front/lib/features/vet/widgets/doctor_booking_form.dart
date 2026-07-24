import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:front/widgets/custom_button.dart';
import '../providers/doctor_booking_provider.dart';
import '../widgets/booking_date_field.dart';
import '../widgets/section_title.dart';
import '../widgets/slot_picker.dart';

class DoctorBookingForm extends StatelessWidget {
  const DoctorBookingForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DoctorBookingProvider>(
      builder: (context, p, _) {
        final doctor = p.doctor;
        if (doctor == null) return const SizedBox.shrink();

        final bottomPadding = MediaQuery.of(context).padding.bottom;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionTitle(
              title: 'Select Pet',
              subtitle: 'Choose the pet for this appointment',
            ),
            const SizedBox(height: 12),
            if (p.pets.isEmpty)
              const _HintCard(
                icon: Icons.pets_rounded,
                title: 'No pets found',
                subtitle: 'Add a pet before booking an appointment.',
              )
            else
              SizedBox(
                height: 50,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: p.pets.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (_, i) {
                    final pet = p.pets[i];
                    final selected = p.selectedPet?.id == pet.id;

                    return ChoiceChip(
                      label: Text(pet.name),
                      selected: selected,
                      onSelected: (_) => p.selectPet(pet),
                    );
                  },
                ),
              ),
            const SizedBox(height: 20),
            const SectionTitle(
              title: 'Available Dates',
              subtitle: 'Tap one of the available days',
            ),
            const SizedBox(height: 12),
            if (p.availableDates.isEmpty)
              const _HintCard(
                icon: Icons.event_busy_rounded,
                title: 'No available dates',
                subtitle: 'This doctor has no open slots in the next 30 days.',
              )
            else
              SizedBox(
                height: 98,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: p.availableDates.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (_, i) {
                    final d = p.availableDates[i];
                    final selected =
                        p.selectedDate != null &&
                        DateUtils.isSameDay(p.selectedDate, d);

                    return BookingDateChip(
                      date: d,
                      selected: selected,
                      onTap: () => p.selectDate(d),
                    );
                  },
                ),
              ),
            const SizedBox(height: 20),
            const SectionTitle(
              title: 'Available Time',
              subtitle: 'Pick one time slot',
            ),
            const SizedBox(height: 12),
            SlotPicker(
              slots: p.availableSlots,
              selectedSlot: p.selectedSlot,
              onSelected: p.selectSlot,
            ),
            const SizedBox(height: 20),
            const SectionTitle(title: 'Reason', subtitle: 'Write a short note'),
            const SizedBox(height: 12),
            TextFormField(
              initialValue: p.reason,
              maxLines: 3,
              onChanged: p.setReason,
              decoration: InputDecoration(
                hintText: 'Example: vaccination, checkup...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: Colors.green, width: 1.5),
                ),
              ),
            ),
            if (p.error != null) ...[
              const SizedBox(height: 16),
              _ErrorBanner(message: p.error!),
            ],
            if (p.booked != null) ...[
              const SizedBox(height: 16),
              _SuccessBanner(id: p.booked!.id),
            ],
            SizedBox(height: 20 + bottomPadding),
            CustomButton(
              text: p.submitting ? 'Booking...' : 'Book Appointment',
              onPressed: p.canBook
                  ? () async {
                      try {
                        await p.book();
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Appointment booked')),
                          );
                        }
                      } catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(
                            context,
                          ).showSnackBar(SnackBar(content: Text(e.toString())));
                        }
                      }
                    }
                  : null,
              isLoading: p.submitting,
              icon: Icons.event_available_rounded,
            ),
          ],
        );
      },
    );
  }
}

class _HintCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _HintCard({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest.withOpacity(0.35),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(icon, color: cs.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: cs.onSurface,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(color: cs.onSurfaceVariant, height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorBanner extends StatelessWidget {
  final String message;

  const _ErrorBanner({required this.message});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cs.errorContainer.withOpacity(0.45),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        message,
        style: TextStyle(
          color: cs.onErrorContainer,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _SuccessBanner extends StatelessWidget {
  final int id;

  const _SuccessBanner({required this.id});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cs.primary.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        'Booked successfully. Appointment #$id',
        style: TextStyle(color: cs.primary, fontWeight: FontWeight.w700),
      ),
    );
  }
}
