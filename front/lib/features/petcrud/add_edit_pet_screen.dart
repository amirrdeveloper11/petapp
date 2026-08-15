import 'package:flutter/material.dart';
import 'package:front/widgets/app_filter_chip.dart';
import 'package:front/widgets/custom_text_field.dart';
import 'package:provider/provider.dart';
import 'package:front/core/theme.dart';
import 'package:front/widgets/custom_button.dart';
import 'package:front/features/petcrud/provider/pet_provider.dart';
import 'package:front/features/petcrud/model/pet_model.dart';
import 'pet_image_picker.dart';

const List<_PetTypeOption> _kPetTypes = [
  _PetTypeOption('Dog', Icons.pets_rounded),
  _PetTypeOption('Cat', Icons.pets_rounded),
  _PetTypeOption('Bird', Icons.category_rounded),
  _PetTypeOption('Rabbit', Icons.pets_rounded),
  _PetTypeOption('Other', Icons.more_horiz_rounded),
];

class _PetTypeOption {
  final String label;
  final IconData icon;
  const _PetTypeOption(this.label, this.icon);
}

class AddEditPetScreen extends StatefulWidget {
  final PetModel? pet;
  const AddEditPetScreen({super.key, this.pet});

  @override
  State<AddEditPetScreen> createState() => _AddEditPetScreenState();
}

class _AddEditPetScreenState extends State<AddEditPetScreen> {
  final _formKey = GlobalKey<FormState>();

  final nameCtrl = TextEditingController();
  final customTypeCtrl = TextEditingController();
  final breedCtrl = TextEditingController();
  final weightCtrl = TextEditingController();

  String? imagePath;
  DateTime? birthDate;
  String gender = 'Male';
  String selectedType = 'Dog';

  bool _saving = false;
  String? _dateError;

  bool get _isOtherType => selectedType == 'Other';

  @override
  void initState() {
    super.initState();
    final p = widget.pet;
    if (p != null) {
      nameCtrl.text = p.name;
      breedCtrl.text = p.breed;
      weightCtrl.text = p.weight.toString();
      imagePath = p.imagePath;
      birthDate = p.birthDate;
      gender = p.gender;

      final match = _kPetTypes.firstWhere(
        (t) => t.label.toLowerCase() == p.type.trim().toLowerCase(),
        orElse: () => const _PetTypeOption('Other', Icons.category_rounded),
      );
      selectedType = match.label;
      if (selectedType == 'Other') {
        customTypeCtrl.text = p.type;
      }
    }
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    customTypeCtrl.dispose();
    breedCtrl.dispose();
    weightCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickBirthDate() async {
    final date = await showDatePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      initialDate: birthDate ?? DateTime.now(),
    );
    if (date != null) {
      setState(() {
        birthDate = date;
        _dateError = null;
      });
    }
  }

  Future<void> _submit() async {
    final formValid = _formKey.currentState!.validate();

    setState(() {
      _dateError = birthDate == null ? 'Please select a birth date' : null;
    });

    if (!formValid || birthDate == null) return;

    setState(() => _saving = true);

    final resolvedType =
        _isOtherType ? customTypeCtrl.text.trim() : selectedType;

    final pet = PetModel(
      id: widget.pet?.id ?? 0,
      name: nameCtrl.text.trim(),
      type: resolvedType,
      breed: breedCtrl.text.trim(),
      weight: double.tryParse(weightCtrl.text) ?? 0,
      gender: gender,
      birthDate: birthDate!,
      imagePath: imagePath,
    );

    final provider = context.read<PetProvider>();

    try {
      if (widget.pet == null) {
        await provider.addPet(pet);
      } else {
        await provider.updatePet(pet.id, pet);
      }

      if (!mounted) return;
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.pet != null;

    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        backgroundColor: AppColors.cream,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.deepTeal),
        title: Text(
          isEdit ? 'Edit Pet' : 'Add Pet',
          style: const TextStyle(
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Center(
              child: PetImagePicker(
                imagePath: imagePath,
                onPicked: (path) => setState(() => imagePath = path),
              ),
            ),
            const SizedBox(height: 28),

            const _FieldLabel('Pet Type'),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _kPetTypes.map((option) {
                final selected = selectedType == option.label;
                return AppFilterPill(
                  label: option.label,
                  icon: option.icon,
                  selected: selected,
                  onTap: () => setState(() => selectedType = option.label),
                );
              }).toList(),
            ),
            if (_isOtherType) ...[
              const SizedBox(height: 12),
              CustomTextField(
                controller: customTypeCtrl,
                hintText: 'Specify pet type',
                prefixIcon: Icons.edit_outlined,
                validator: (v) => v == null || v.trim().isEmpty
                    ? 'Please specify the pet type'
                    : null,
              ),
            ],
            const SizedBox(height: 20),

            const _FieldLabel('Basic Info'),
            const SizedBox(height: 4),
            CustomTextField(
              controller: nameCtrl,
              hintText: 'Pet Name',
              prefixIcon: Icons.badge_outlined,
              validator: (v) =>
                  v == null || v.trim().isEmpty ? 'Required' : null,
            ),

            CustomTextField(
              controller: breedCtrl,
              hintText: 'Breed',
              prefixIcon: Icons.pets_outlined,
              validator: (v) =>
                  v == null || v.trim().isEmpty ? 'Required' : null,
            ),

            CustomTextField(
              controller: weightCtrl,
              hintText: 'Weight (kg)',
              prefixIcon: Icons.monitor_weight_outlined,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Required';
                final n = double.tryParse(v);
                if (n == null) return 'Invalid number';
                if (n <= 0) return 'Weight must be greater than 0';
                return null;
              },
            ),
            const SizedBox(height: 16),

            const _FieldLabel('Gender'),
            const SizedBox(height: 8),
            SegmentedButton<String>(
              style: SegmentedButton.styleFrom(
                selectedBackgroundColor: AppColors.deepTeal,
                selectedForegroundColor: Colors.white,
                foregroundColor: AppColors.textPrimary,
                backgroundColor: AppColors.ivory,
                side: const BorderSide(color: AppColors.hairline),
              ),
              segments: const [
                ButtonSegment(
                  value: 'Male',
                  label: Text('Male'),
                  icon: Icon(Icons.male_rounded),
                ),
                ButtonSegment(
                  value: 'Female',
                  label: Text('Female'),
                  icon: Icon(Icons.female_rounded),
                ),
              ],
              selected: {gender},
              onSelectionChanged: (v) => setState(() => gender = v.first),
            ),
            const SizedBox(height: 20),

            const _FieldLabel('Birth Date'),
            const SizedBox(height: 8),
            Material(
              color: AppColors.tealSoft,
              borderRadius: BorderRadius.circular(AppRadii.md),
              child: InkWell(
                borderRadius: BorderRadius.circular(AppRadii.md),
                onTap: _pickBirthDate,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.calendar_month_rounded,
                        color: AppColors.deepTeal,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          birthDate == null
                              ? 'Select Birth Date'
                              : '${birthDate!.day}/${birthDate!.month}/${birthDate!.year}',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: birthDate == null
                                ? AppColors.textSecondary
                                : AppColors.textPrimary,
                          ),
                        ),
                      ),
                      const Icon(
                        Icons.chevron_right_rounded,
                        color: AppColors.textSecondary,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (_dateError != null) ...[
              const SizedBox(height: 6),
              Text(
                _dateError!,
                style: const TextStyle(
                  color: AppColors.danger,
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
            const SizedBox(height: 32),

            CustomButton(
              text: _saving
                  ? 'Please wait...'
                  : (isEdit ? 'Update Pet' : 'Add Pet'),
              onPressed: _saving ? null : _submit,
              isLoading: _saving,
              icon: isEdit ? Icons.save_rounded : Icons.add_rounded,
            ),
          ],
        ),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.w700,
          color: AppColors.textSecondary,
          fontSize: 13,
        ),
      ),
    );
  }
}
