import 'package:flutter/material.dart';
import 'package:front/core/theme.dart';
import 'package:front/features/petcrud/model/pet_constants.dart';
import 'package:front/features/petcrud/model/pet_model.dart';
import 'package:front/features/petcrud/provider/pet_provider.dart';
import 'package:front/widgets/custom_button.dart';
import 'package:front/widgets/custom_pdropdown.dart';
import 'package:provider/provider.dart';
import 'pet_image_picker.dart';

class AddEditPetScreen extends StatefulWidget {
  final PetModel? pet;
  const AddEditPetScreen({super.key, this.pet});

  @override
  State<AddEditPetScreen> createState() => _AddEditPetScreenState();
}

class _AddEditPetScreenState extends State<AddEditPetScreen> {
  final formKey = GlobalKey<FormState>();

  final nameCtrl = TextEditingController();
  final weightCtrl = TextEditingController();

  String? type;
  String? breed;
  String? imagePath;
  DateTime? birthDate;
  String gender = 'Male';

  List<String> get breeds {
    switch (type) {
      case 'Dog':
        return dogBreeds;
      case 'Cat':
        return catBreeds;
      case 'Bird':
        return birdBreeds;
      default:
        return [];
    }
  }

  @override
  void initState() {
    super.initState();
    final p = widget.pet;
    if (p != null) {
      nameCtrl.text = p.name;
      weightCtrl.text = p.weight.toString();
      type = p.type;
      breed = p.breed;
      imagePath = p.imagePath;
      birthDate = p.birthDate;
      gender = p.gender;
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.read<PetProvider>();
    return Scaffold(
      appBar: AppBar(title: Text(widget.pet == null ? 'Add Pet' : 'Edit Pet')),
      body: Form(
        key: formKey,
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

            TextFormField(
              controller: nameCtrl,
              decoration: const InputDecoration(labelText: 'Pet Name'),
              validator: (v) => v!.isEmpty ? 'Required' : null,
            ),

            const SizedBox(height: 16),

            CustomM3Dropdown<String>(
              label: 'Pet Type',
              value: type,
              items: petTypes,
              labelBuilder: (e) => e,
              onChanged: (v) {
                setState(() {
                  type = v;
                  breed = null;
                });
              },
            ),

            const SizedBox(height: 16),

            CustomM3Dropdown<String>(
              label: 'Breed',
              value: breed,
              items: breeds,
              labelBuilder: (e) => e,
              onChanged: (v) => setState(() => breed = v),
            ),

            const SizedBox(height: 16),

            TextFormField(
              controller: weightCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Weight (kg)'),
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
              onSelectionChanged: (v) {
                setState(() => gender = v.first);
              },
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
                );
                if (date != null) setState(() => birthDate = date);
              },
            ),

            const SizedBox(height: 32),

            CustomButton(
              text: widget.pet == null ? 'Add Pet' : 'Update Pet',
              onPressed: () {
                if (!formKey.currentState!.validate() ||
                    type == null ||
                    breed == null ||
                    birthDate == null)
                  return;

                final pet = PetModel(
                  id: widget.pet?.id ?? provider.generateId(),
                  name: nameCtrl.text,
                  type: type!,
                  breed: breed!,
                  birthDate: birthDate!,
                  gender: gender,
                  weight: double.tryParse(weightCtrl.text) ?? 0,
                  imagePath: imagePath,
                );

                widget.pet == null
                    ? provider.addPet(pet)
                    : provider.updatePet(pet.id, pet);

                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
