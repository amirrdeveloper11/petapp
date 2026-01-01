import 'package:flutter/material.dart';
import 'package:front/core/theme.dart';

class VetSection extends StatelessWidget {
  const VetSection({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text("Pet Health Records", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        ...List.generate(3, (index) {
          return Card(
            child: ListTile(
              leading: const Icon(Icons.medical_services, color: AppColors.primaryGreen),
              title: Text("Checkup ${index + 1}"),
              subtitle: const Text("Vaccination and health review"),
              trailing: const Icon(Icons.visibility),
            ),
          );
        }),
      ],
    );
  }
}
