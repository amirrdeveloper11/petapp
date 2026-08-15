import 'package:flutter/material.dart';
import 'package:front/core/theme.dart';

class AppStatusChip extends StatelessWidget {
  final String status;
  final bool compact;

  const AppStatusChip({super.key, required this.status, this.compact = false});

  Color _resolveColor(BuildContext context) {
    final normalized = status.trim().toLowerCase();

    if (normalized.contains('expired')) return AppColors.muted;
    if (normalized.contains('cancel')) return AppColors.danger;
    if (normalized.contains('complete') || normalized.contains('done')) {
      return AppColors.success;
    }
    if (normalized.contains('process')) return Colors.indigo;
    if (normalized.contains('resched')) return AppColors.gold;
    if (normalized.contains('confirm') || normalized.contains('accept')) {
      return AppColors.teal;
    }
    if (normalized.contains('pending') || normalized.contains('request')) {
      return Colors.orange.shade800;
    }

    return AppColors.deepTeal;
  }

  String _prettyLabel() {
    final value = status.trim();
    if (value.isEmpty) return 'Unknown';
    return value
        .replaceAll('_', ' ')
        .split(' ')
        .where((part) => part.trim().isNotEmpty)
        .map((part) => '${part[0].toUpperCase()}${part.substring(1)}')
        .join(' ');
  }

  @override
  Widget build(BuildContext context) {
    final color = _resolveColor(context);

    return Chip(
      visualDensity: compact ? VisualDensity.compact : VisualDensity.standard,
      side: BorderSide(color: color.withOpacity(0.18)),
      backgroundColor: color.withOpacity(0.08),
      label: Text(
        _prettyLabel(),
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w800,
          fontSize: compact ? 11.5 : 12,
        ),
      ),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
      padding: EdgeInsets.zero,
    );
  }
}
