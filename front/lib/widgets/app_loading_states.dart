import 'package:flutter/material.dart';
import 'package:front/core/theme.dart';
import 'package:front/widgets/app_shimmer.dart';

/// Shimmer placeholder for a vertical list of cards (doctors, appointments,
/// orders...). Matches the rounded, ivory-card rhythm used everywhere else.
class AppListShimmer extends StatelessWidget {
  final int itemCount;
  final double itemHeight;
  final EdgeInsetsGeometry padding;

  const AppListShimmer({
    super.key,
    this.itemCount = 5,
    this.itemHeight = 108,
    this.padding = const EdgeInsets.fromLTRB(16, 12, 16, 16),
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: padding,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: itemCount,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, __) => AppShimmer(
        height: itemHeight,
        width: double.infinity,
        borderRadius: BorderRadius.circular(AppRadii.xl),
      ),
    );
  }
}

/// Shimmer placeholder for a 2-column product grid (Store).
class AppGridShimmer extends StatelessWidget {
  final int itemCount;
  final EdgeInsetsGeometry padding;

  const AppGridShimmer({
    super.key,
    this.itemCount = 6,
    this.padding = EdgeInsets.zero,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: padding,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: itemCount,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 14,
        crossAxisSpacing: 14,
        childAspectRatio: 0.74,
      ),
      itemBuilder: (_, __) => AppShimmer(
        height: 220,
        width: double.infinity,
        borderRadius: BorderRadius.circular(AppRadii.xl),
      ),
    );
  }
}
