import 'package:flutter/material.dart';
import 'package:front/widgets/custom_text_field.dart';
import 'package:provider/provider.dart';
import 'package:front/core/theme.dart';
import 'package:front/widgets/custom_button.dart';
import 'package:front/features/petcrud/provider/pet_provider.dart';
import 'package:front/features/petcrud/model/pet_model.dart';
import 'pet_image_picker.dart';

class AddEditPetScreen extends StatefulWidget {
  final PetModel? pet;
  const AddEditPetScreen({super.key, this.pet});

  @override
  State<AddEditPetScreen> createState() => _AddEditPetScreenState();
}

class _AddEditPetScreenState extends State<AddEditPetScreen> {
  final _formKey = GlobalKey<FormState>();

  final nameCtrl = TextEditingController();
  final typeCtrl = TextEditingController();
  final breedCtrl = TextEditingController();
  final weightCtrl = TextEditingController();

  String? imagePath;
  DateTime? birthDate;
  String gender = 'Male';

  @override
  void initState() {
    super.initState();
    final p = widget.pet;
    if (p != null) {
      nameCtrl.text = p.name;
      typeCtrl.text = p.type;
      breedCtrl.text = p.breed;
      weightCtrl.text = p.weight.toString();
      imagePath = p.imagePath;
      birthDate = p.birthDate;
      gender = p.gender;
    }
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    typeCtrl.dispose();
    breedCtrl.dispose();
    weightCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.read<PetProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.pet == null ? 'Add Pet' : 'Edit Pet'),
        backgroundColor: AppColors.primaryGreen,
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
            const SizedBox(height: 24),

            CustomTextField(
              controller: nameCtrl,
              hintText: 'Pet Name',
              validator: (v) => v!.isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: 16),

            CustomTextField(
              controller: typeCtrl,
              hintText: 'Pet Type',
              validator: (v) => v!.isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: 16),

            // Breed
            CustomTextField(
              controller: breedCtrl,
              hintText: 'Breed',
              validator: (v) => v!.isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: 16),

            // Weight
            CustomTextField(
              controller: weightCtrl,
              hintText: 'Weight (kg)',
              keyboardType: TextInputType.number,
              validator: (v) {
                if (v == null || v.isEmpty) return null;
                final n = double.tryParse(v);
                if (n == null) return 'Invalid number';
                return null;
              },
            ),
            const SizedBox(height: 16),

            SegmentedButton<String>(
              segments: const [
                ButtonSegment(
                  value: 'Male',
                  label: Text('Male'),
                  icon: Icon(Icons.male),
                ),
                ButtonSegment(
                  value: 'Female',
                  label: Text('Female'),
                  icon: Icon(Icons.female),
                ),
              ],
              selected: {gender},
              onSelectionChanged: (v) => setState(() => gender = v.first),
            ),
            const SizedBox(height: 16),

            ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              tileColor: AppColors.softBackground,
              title: Text(
                birthDate == null
                    ? 'Select Birth Date'
                    : '${birthDate!.day}/${birthDate!.month}/${birthDate!.year}',
                style: TextStyle(
                  color: birthDate == null
                      ? AppColors.muted
                      : AppColors.textPrimary,
                ),
              ),
              trailing: Icon(
                Icons.calendar_month,
                color: AppColors.primaryGreen,
              ),
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  firstDate: DateTime(2000),
                  lastDate: DateTime.now(),
                  initialDate: birthDate ?? DateTime.now(),
                );
                if (date != null) setState(() => birthDate = date);
              },
            ),
            const SizedBox(height: 32),

            CustomButton(
              text: widget.pet == null ? 'Add Pet' : 'Update Pet',
              onPressed: () {
                if (!_formKey.currentState!.validate() || birthDate == null)
                  return;

                final pet = PetModel(
                  id: widget.pet?.id ?? 0,
                  name: nameCtrl.text.trim(),
                  type: typeCtrl.text.trim(),
                  breed: breedCtrl.text.trim(),
                  weight: double.tryParse(weightCtrl.text) ?? 0,
                  gender: gender,
                  birthDate: birthDate!,
                  imagePath: imagePath,
                );

                if (widget.pet == null) {
                  provider.addPet(pet);
                } else {
                  provider.updatePet(pet.id, pet);
                }

                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
