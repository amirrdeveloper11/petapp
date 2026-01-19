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
            //Image
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: SizedBox(
                width: 80,
                height: 80,
                child: _buildImage(pet.imagePath, scheme),
              ),
            ),
            const SizedBox(width: 12),

            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    pet.name,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "${pet.type} • ${pet.breed}",
                    style: Theme.of(context).textTheme.bodySmall,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: [
                      _chip(
                        pet.gender == 'Male' ? Icons.male : Icons.female,
                        pet.gender,
                      ),
                      _chip(Icons.cake, "${pet.age} yrs"),
                      _chip(Icons.monitor_weight, "${pet.weight} kg"),
                    ],
                  ),
                ],
              ),
            ),
            //Menu
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

  // 🖼 Image helper
  Widget _buildImage(String? path, ColorScheme scheme) {
    if (path == null) {
      return Container(
        color: scheme.primaryContainer,
        child: Icon(Icons.pets, size: 40, color: scheme.primary),
      );
    } else if (path.startsWith('http')) {
      return Image.network(
        path,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) {
          return const Center(child: Icon(Icons.broken_image));
        },
      );
    } else {
      final file = File(path);
      return file.existsSync()
          ? Image.file(file, fit: BoxFit.cover)
          : const Center(child: Icon(Icons.broken_image));
    }
  }

  // ⚡ Chip helper to reduce widget nesting
  Widget _chip(IconData icon, String label) {
    return Chip(
      avatar: Icon(icon, size: 16),
      label: Text(label, overflow: TextOverflow.ellipsis),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      visualDensity: VisualDensity.compact,
    );
  }
}
