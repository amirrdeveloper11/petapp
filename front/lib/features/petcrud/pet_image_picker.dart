import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PetImagePicker extends StatelessWidget {
  final String? imagePath;
  final void Function(String path) onPicked;

  const PetImagePicker({
    super.key,
    required this.imagePath,
    required this.onPicked,
  });

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) onPicked(image.path);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _pickImage,
      child: CircleAvatar(
        radius: 52,
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        backgroundImage:
            imagePath != null ? FileImage(File(imagePath!)) : null,
        child: imagePath == null
            ? const Icon(Icons.add_a_photo, size: 32)
            : null,
      ),
    );
  }
}
