import 'package:flutter/material.dart';
import 'package:front/core/theme.dart';
import 'package:front/features/petcrud/add_edit_pet_screen.dart';
import 'package:front/features/petcrud/pet_card.dart';
import 'package:front/features/petcrud/provider/pet_provider.dart';
import 'package:front/widgets/app_card.dart';
import 'package:front/widgets/app_empty_state.dart';
import 'package:front/widgets/app_loading_states.dart';
import 'package:front/widgets/custom_button.dart';
import 'package:provider/provider.dart';

class PetListScreen extends StatefulWidget {
  const PetListScreen({super.key});

  @override
  State<PetListScreen> createState() => _PetListScreenState();
}

class _PetListScreenState extends State<PetListScreen> {
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

    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        backgroundColor: AppColors.cream,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.deepTeal),
        title: const Text(
          'My Pets',
          style: TextStyle(
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
      ),
      body: RefreshIndicator(
        color: AppColors.teal,
        onRefresh: provider.fetchPets,
        child: _buildBody(provider),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: CustomButton(
            text: 'Add Pet',
            icon: Icons.add_rounded,
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

  Widget _buildBody(PetProvider provider) {
    if (provider.loading && provider.pets.isEmpty) {
      return const AppListShimmer();
    }

    if (provider.error != null && provider.pets.isEmpty) {
      return ListView(
        padding: const EdgeInsets.all(16),
        children: [
          AppEmptyState(
            icon: Icons.error_outline_rounded,
            title: 'Could not load pets',
            subtitle: provider.error!,
            actionLabel: 'Retry',
            onAction: provider.fetchPets,
          ),
        ],
      );
    }

    if (provider.pets.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: const [
          SizedBox(height: 60),
          AppEmptyState(
            icon: Icons.pets_rounded,
            title: 'No pets yet',
            subtitle: 'Add your first pet to manage health\nand vet records.',
          ),
        ],
      );
    }

    final pets = provider.pets;
    final dogCount = pets.where((p) => p.type.toLowerCase() == 'dog').length;
    final catCount = pets.where((p) => p.type.toLowerCase() == 'cat').length;
    final otherCount = pets.length - dogCount - catCount;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
      children: [
        AppCard(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
          child: Row(
            children: [
              _StatColumn(
                icon: Icons.pets_rounded,
                value: '${pets.length}',
                label: pets.length == 1 ? 'Total pet' : 'Total pets',
                color: AppColors.deepTeal,
              ),
              _divider(),
              _StatColumn(
                icon: Icons.pets_outlined,
                value: '$dogCount',
                label: 'Dogs',
                color: AppColors.primaryGreenDark,
              ),
              _divider(),
              _StatColumn(
                icon: Icons.pets_outlined,
                value: '$catCount',
                label: 'Cats',
                color: AppColors.secondaryOrange,
              ),
              if (otherCount > 0) ...[
                _divider(),
                _StatColumn(
                  icon: Icons.pets_outlined,
                  value: '$otherCount',
                  label: 'Other',
                  color: AppColors.gold,
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 16),
        ...pets.map((p) => PetCard(pet: p)),
      ],
    );
  }

  Widget _divider() {
    return Container(
      width: 1,
      height: 36,
      color: AppColors.hairline,
    );
  }
}

class _StatColumn extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;

  const _StatColumn({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary.withOpacity(0.85),
            ),
          ),
        ],
      ),
    );
  }
}
