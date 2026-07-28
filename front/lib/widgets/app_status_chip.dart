import 'package:flutter/material.dart';

class AppStatusChip extends StatelessWidget {
  final String status;
  final bool compact;

  const AppStatusChip({super.key, required this.status, this.compact = false});

  Color _resolveColor(BuildContext context) {
    final normalized = status.trim().toLowerCase();
    final cs = Theme.of(context).colorScheme;

    if (normalized.contains('expired')) return cs.outline;
    if (normalized.contains('cancel')) return cs.error;
    if (normalized.contains('complete') || normalized.contains('done')) {
      return Colors.green;
    }
    if (normalized.contains('process')) return Colors.indigo;
    if (normalized.contains('resched')) return Colors.deepPurple;
    if (normalized.contains('confirm') || normalized.contains('accept')) {
      return Colors.blue;
    }
    if (normalized.contains('pending') || normalized.contains('request')) {
      return Colors.orange;
    }

    return cs.primary;
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
