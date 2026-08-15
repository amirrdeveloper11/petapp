import 'dart:io';
import 'package:flutter/material.dart';
import 'package:front/core/theme.dart';
import 'package:front/features/petcrud/pet_list_screen.dart';
import 'package:front/features/petcrud/provider/pet_provider.dart';
import 'package:front/widgets/app_card.dart';
import 'package:provider/provider.dart';

class ProfilePetsSection extends StatefulWidget {
  const ProfilePetsSection({super.key});

  @override
  State<ProfilePetsSection> createState() => _ProfilePetsSectionState();
}

class _ProfilePetsSectionState extends State<ProfilePetsSection> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PetProvider>().fetchPets();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PetProvider>();
    final pets = provider.pets;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'My Pets',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const PetListScreen()),
                  );
                },
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.deepTeal,
                ),
                child: const Text(
                  'Manage',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          if (provider.loading && pets.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Center(
                child: CircularProgressIndicator(color: AppColors.teal),
              ),
            )
          else if (pets.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                'No pets added yet',
                style: TextStyle(
                  color: AppColors.textSecondary.withOpacity(0.9),
                  fontWeight: FontWeight.w600,
                ),
              ),
            )
          else
            SizedBox(
              height: 116,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: pets.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (_, i) {
                  final pet = pets[i];
                  return Container(
                    width: 96,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.tealSoft,
                      borderRadius: BorderRadius.circular(AppRadii.md),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(AppRadii.sm),
                          child: SizedBox(
                            width: 56,
                            height: 56,
                            child: _buildPetImage(pet.imagePath),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          pet.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        Text(
                          '${pet.age} y',
                          style: TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSecondary.withOpacity(0.9),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPetImage(String? path) {
    if (path == null || path.trim().isEmpty) {
      return const Center(
        child: Icon(Icons.pets_rounded, size: 28, color: AppColors.deepTeal),
      );
    }
    if (path.startsWith('http')) {
      return Image.network(
        path,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => const Center(
          child: Icon(
            Icons.broken_image_rounded,
            size: 22,
            color: AppColors.deepTeal,
          ),
        ),
      );
    }
    final file = File(path);
    return file.existsSync()
        ? Image.file(file, fit: BoxFit.cover)
        : const Center(
            child: Icon(
              Icons.broken_image_rounded,
              size: 22,
              color: AppColors.deepTeal,
            ),
          );
  }
}
