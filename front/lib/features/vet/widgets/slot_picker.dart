import 'package:flutter/material.dart';
import 'package:front/core/theme.dart';

import 'time_slot_chip.dart';

class SlotPicker extends StatelessWidget {
  final List<String> slots;
  final String? selectedSlot;
  final ValueChanged<String> onSelected;

  const SlotPicker({
    super.key,
    required this.slots,
    required this.selectedSlot,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    if (slots.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.tealSoft,
          borderRadius: BorderRadius.circular(AppRadii.md),
        ),
        child: const Text(
          'No available slots for this day.',
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    }

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: slots.map((slot) {
        final selected = slot == selectedSlot;
        return TimeSlotChip(
          label: slot,
          selected: selected,
          onTap: () => onSelected(slot),
        );
      }).toList(),
    );
  }
}
