import 'package:flutter/material.dart';

class CustomM3Dropdown<T> extends StatelessWidget {
  final String label;
  final T? value;
  final List<T> items;
  final String Function(T) labelBuilder;
  final ValueChanged<T?> onChanged;

  const CustomM3Dropdown({
    super.key,
    required this.label,
    required this.value,
    required this.items,
    required this.labelBuilder,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
      ),
      items: items
          .map(
            (e) => DropdownMenuItem(
              value: e,
              child: Text(labelBuilder(e)),
            ),
          )
          .toList(),
      onChanged: onChanged,
    );
  }
}
