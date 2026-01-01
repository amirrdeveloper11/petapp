import 'dart:io';

import 'package:flutter/material.dart';
import 'package:front/features/petcrud/add_edit_pet_screen.dart';
import 'package:front/features/petcrud/model/pet_model.dart';
import 'package:front/features/petcrud/provider/pet_provider.dart';
import 'package:provider/provider.dart';

class PetCard extends StatelessWidget {
  final PetModel pet;
  const PetCard({super.key, required this.pet});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: pet.imagePath != null
                  ? Image.file(
                      File(pet.imagePath!),
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                    )
                  : Container(
                      width: 80,
                      height: 80,
                      color: scheme.primaryContainer,
                      child: Icon(Icons.pets, size: 40, color: scheme.primary),
                    ),
            ),

            const SizedBox(width: 12),

            // 📄 Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    pet.name,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    "${pet.type} • ${pet.breed}",
                    style: Theme.of(context).textTheme.bodySmall,
                  ),

                  const SizedBox(height: 8),

                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: [
                      _InfoChip(
                        icon: pet.gender == 'Male' ? Icons.male : Icons.female,
                        label: pet.gender,
                      ),
                      _InfoChip(icon: Icons.cake, label: "${pet.age} yrs"),
                      _InfoChip(
                        icon: Icons.monitor_weight,
                        label: "${pet.weight} kg",
                      ),
                    ],
                  ),
                ],
              ),
            ),

            PopupMenuButton(
              itemBuilder: (_) => const [
                PopupMenuItem(value: 'edit', child: Text("Edit")),
                PopupMenuItem(value: 'delete', child: Text("Delete")),
              ],
              onSelected: (value) {
                if (value == 'edit') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AddEditPetScreen(pet: pet),
                    ),
                  );
                } else {
                  context.read<PetProvider>().deletePet(pet.id);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: Icon(icon, size: 16),
      label: Text(label),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      visualDensity: VisualDensity.compact,
    );
  }
}
