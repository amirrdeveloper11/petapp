import 'package:flutter/material.dart';
import 'package:front/widgets/app_filter_chip.dart';

import '../models/specialty_model.dart';

class SpecialtyFilterChips extends StatelessWidget {
  final List<SpecialtyModel> specialties;
  final int? selectedId;
  final ValueChanged<int?> onSelected;

  const SpecialtyFilterChips({
    super.key,
    required this.specialties,
    required this.selectedId,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          AppFilterPill(
            label: 'All',
            selected: selectedId == null,
            icon: Icons.apps_rounded,
            onTap: () => onSelected(null),
          ),
          const SizedBox(width: 8),
          ...specialties.map(
            (s) => Padding(
              padding: const EdgeInsets.only(right: 8),
              child: AppFilterPill(
                label: s.name,
                selected: selectedId == s.id,
                onTap: () => onSelected(selectedId == s.id ? null : s.id),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
