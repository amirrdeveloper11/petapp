import 'package:flutter/material.dart';
import 'package:front/widgets/app_search_field.dart';

/// Thin wrapper kept for backward compatibility with existing call sites —
/// now simply delegates to the shared, app-wide [AppSearchField] so the
/// Store search bar matches Home's search pill exactly.
class StoreSearchBar extends StatelessWidget {
  final ValueChanged<String> onChanged;

  const StoreSearchBar({super.key, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return AppSearchField(
      hintText: 'Search products',
      onChanged: onChanged,
    );
  }
}
