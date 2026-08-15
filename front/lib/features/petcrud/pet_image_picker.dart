import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../core/theme.dart';

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
      child: Stack(
        children: [
          Container(
            width: 108,
            height: 108,
            decoration: BoxDecoration(
              color: AppColors.tealSoft,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.hairline, width: 1),
            ),
            child: ClipOval(child: _buildImage()),
          ),
          Positioned(
            right: 2,
            bottom: 2,
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppColors.deepTeal,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.cream, width: 2),
              ),
              child: const Icon(
                Icons.edit_rounded,
                size: 15,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImage() {
    final path = imagePath;

    if (path == null || path.trim().isEmpty) {
      return const Icon(
        Icons.add_a_photo_rounded,
        size: 32,
        color: AppColors.deepTeal,
      );
    }

    if (path.startsWith('http')) {
      return Image.network(
        path,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => const Icon(
          Icons.broken_image_rounded,
          color: AppColors.deepTeal,
        ),
      );
    }

    final file = File(path);
    return file.existsSync()
        ? Image.file(file, fit: BoxFit.cover)
        : const Icon(Icons.broken_image_rounded, color: AppColors.deepTeal);
  }
}
