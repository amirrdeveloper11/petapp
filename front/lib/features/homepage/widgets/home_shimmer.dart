import 'package:flutter/material.dart';
import 'package:front/widgets/app_shimmer.dart';

class HomeShimmer extends StatelessWidget {
  const HomeShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      children: [
        const SizedBox(height: 8),

        Row(
          children: [
            Expanded(
              child: AppShimmer(
                height: 56,
                width: double.infinity,
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            const SizedBox(width: 12),
             AppShimmer(
              height: 56,
              width: 56,
              borderRadius: BorderRadius.circular(28),
            ),
          ],
        ),

        const SizedBox(height: 20),

        const AppShimmer(
          height: 150,
          width: double.infinity,
          borderRadius: BorderRadius.all(Radius.circular(28)),
        ),

        const SizedBox(height: 20),

        const AppShimmer(
          height: 24,
          width: 160,
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),

        const SizedBox(height: 14),

        SizedBox(
          height: 92,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: 6,
            separatorBuilder: (_, __) => const SizedBox(width: 14),
            itemBuilder: (_, __) => const AppShimmer(
              height: 78,
              width: 78,
              borderRadius: BorderRadius.all(Radius.circular(39)),
            ),
          ),
        ),

        const SizedBox(height: 18),

        const AppShimmer(
          height: 24,
          width: 180,
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),

        const SizedBox(height: 14),

        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 4,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.74,
            crossAxisSpacing: 14,
            mainAxisSpacing: 14,
          ),
          itemBuilder: (_, __) => const AppShimmer(
            height: 220,
            width: double.infinity,
            borderRadius: BorderRadius.all(Radius.circular(24)),
          ),
        ),
      ],
    );
  }
}