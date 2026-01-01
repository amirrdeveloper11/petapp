import 'package:flutter/material.dart';
import 'package:front/features/petcrud/pet_list_screen.dart';
import 'package:front/features/petcrud/provider/pet_provider.dart';
import 'package:provider/provider.dart';
import 'package:front/core/theme.dart';

class ProfilePetsSection extends StatelessWidget {
  const ProfilePetsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final pets = context.watch<PetProvider>().pets;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "My Pets",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const PetListScreen()),
                    );
                  },
                  child: const Text("Manage"),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (pets.isEmpty)
              const Text("No pets added", style: TextStyle(color: Colors.grey))
            else
              SizedBox(
                height: 90,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: pets.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (_, i) {
                    final pet = pets[i];
                    return Container(
                      width: 120,
                      decoration: BoxDecoration(
                        color: AppColors.primaryGreen.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.pets),
                            Text(pet.name),
                            Text(
                              "${pet.age} y",
                              style: const TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
