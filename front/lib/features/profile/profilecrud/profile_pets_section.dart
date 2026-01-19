import 'dart:io';
import 'package:flutter/material.dart';
import 'package:front/features/petcrud/pet_list_screen.dart';
import 'package:front/features/petcrud/provider/pet_provider.dart';
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

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
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

            // Pets Listt
            if (provider.loading)
              const Center(child: CircularProgressIndicator())
            else if (pets.isEmpty)
              const Text("No pets added", style: TextStyle(color: Colors.grey))
            else
              SizedBox(
                height: 110,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: pets.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (_, i) {
                    final pet = pets[i];
                    return Container(
                      width: 100,
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: SizedBox(
                              width: 60,
                              height: 60,
                              child: _buildPetImage(pet.imagePath),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            pet.name,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "${pet.age} y",
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
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
      ),
    );
  }

  Widget _buildPetImage(String? path) {
    if (path == null) return const Center(child: Icon(Icons.pets, size: 40));
    if (path.startsWith('http')) return Image.network(path, fit: BoxFit.cover);
    final file = File(path);
    return file.existsSync()
        ? Image.file(file, fit: BoxFit.cover)
        : const Center(child: Icon(Icons.broken_image));
  }
}
