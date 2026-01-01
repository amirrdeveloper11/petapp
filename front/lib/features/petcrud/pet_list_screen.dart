import 'package:flutter/material.dart';
import 'package:front/core/theme.dart';
import 'package:front/features/petcrud/pet_card.dart';
import 'package:front/features/petcrud/provider/pet_provider.dart';
import 'package:front/widgets/custom_button.dart';
import 'package:provider/provider.dart';
import 'add_edit_pet_screen.dart';

class PetListScreen extends StatelessWidget {
  const PetListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final pets = context.watch<PetProvider>().pets;

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Pets"),
        backgroundColor: AppColors.primaryGreen,
      ),

      body: pets.isEmpty
          ? const _EmptyPetsState()
          : ListView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
              children: pets.map((p) => PetCard(pet: p)).toList(),
            ),

      // ✅ Bottom Add Button
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: CustomButton(
            text: "Add Pet",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AddEditPetScreen()),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _EmptyPetsState extends StatelessWidget {
  const _EmptyPetsState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.pets,
              size: 72,
              color: AppColors.primaryGreen.withOpacity(0.4),
            ),
            const SizedBox(height: 16),
            const Text(
              "No pets yet",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              "Add your first pet to manage health\nand vet records",
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}
