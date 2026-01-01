import 'package:flutter/material.dart';
import 'package:front/core/theme.dart';

class StoreSection extends StatelessWidget {
  const StoreSection({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: List.generate(5, (index) {
        return Card(
          child: ListTile(
            leading: const Icon(Icons.pets, color: AppColors.primaryGreen),
            title: Text("Product ${index + 1}"),
            subtitle: const Text("Pet product description"),
            trailing: IconButton(
              icon: const Icon(Icons.favorite_border, color: AppColors.primaryGreen),
              onPressed: () {},
            ),
          ),
        );
      }),
    );
  }
}
