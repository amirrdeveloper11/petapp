import 'package:flutter/material.dart';
import 'package:front/core/theme.dart';

/// The base "premium card" used across the whole app: an ivory surface,
/// hairline border and soft shadow, with a consistent radius.
///
/// Centralizing this in one widget means every card in the app — vet cards,
/// product cards, cart rows, order tiles — automatically stays visually
/// consistent, and any future tweak to the app's card language only needs
/// to happen in one place.
class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final double radius;
  final VoidCallback? onTap;
  final Color color;
  final bool bordered;
  final List<BoxShadow>? boxShadow;

  const AppCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.radius = AppRadii.xl,
    this.onTap,
    this.color = AppColors.ivory,
    this.bordered = true,
    this.boxShadow,
  });

  @override
  Widget build(BuildContext context) {
    final content = Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(radius),
        border: bordered
            ? Border.all(color: AppColors.hairline, width: 1)
            : null,
        boxShadow: boxShadow ?? AppShadows.card,
      ),
      child: onTap == null
          ? Padding(padding: padding, child: child)
          : Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(radius),
              child: InkWell(
                borderRadius: BorderRadius.circular(radius),
                onTap: onTap,
                child: Padding(padding: padding, child: child),
              ),
            ),
    );

    return content;
  }
}

/// A rounded icon "chip" used as a leading visual on cards — doctor cards,
/// order tiles, appointment cards, quick actions, etc. Keeps icon
/// containers visually identical everywhere in the app.
class AppIconChip extends StatelessWidget {
  final IconData icon;
  final double size;
  final Color background;
  final Color iconColor;
  final double iconSize;
  final double radius;

  const AppIconChip({
    super.key,
    required this.icon,
    this.size = 52,
    this.background = AppColors.tealSoft,
    this.iconColor = AppColors.deepTeal,
    this.iconSize = 24,
    this.radius = AppRadii.md,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(radius),
      ),
      child: Icon(icon, color: iconColor, size: iconSize),
    );
  }
}

/// Small pill-shaped status/label badge — reused for "In stock", "Available",
/// "Featured", order/appointment statuses, etc.
class AppPillBadge extends StatelessWidget {
  final String label;
  final Color color;
  final IconData? icon;
  final bool solid;

  const AppPillBadge({
    super.key,
    required this.label,
    required this.color,
    this.icon,
    this.solid = false,
  });

  @override
  Widget build(BuildContext context) {
    final fg = solid ? Colors.white : color;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: solid ? color.withOpacity(0.94) : color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(AppRadii.pill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 13, color: fg),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: TextStyle(
              color: fg,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
