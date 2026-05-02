import 'package:flutter/material.dart';
import 'package:front/core/theme.dart';

class HomeBannerCard extends StatelessWidget {
  const HomeBannerCard({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        final titleSize = (w * 0.085).clamp(22.0, 30.0);
        final circleSize = (w * 0.34).clamp(110.0, 145.0);

        return Container(
          height: (w * 0.50).clamp(170.0, 210.0),
          decoration: BoxDecoration(
            color: AppColors.secondaryOrange,
            borderRadius: BorderRadius.circular(28),
          ),
          child: Padding(
            padding: EdgeInsets.all(w * 0.05),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Flash Sale!\n25% Off\nStorewide',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: titleSize,
                          height: 1.05,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(height: w * 0.04),
                      Text(
                        'LIMITED TIME ONLY',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.85),
                          fontSize: (w * 0.033).clamp(11.0, 14.0),
                          letterSpacing: 1.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(width: w * 0.04),

                Align(
                  alignment: Alignment.bottomRight,
                  child: Container(
                    height: circleSize,
                    width: circleSize,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withOpacity(0.35),
                        width: 3,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.16),
                          blurRadius: 16,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.15),
                      ),
                      child: const Icon(
                        Icons.pets_rounded,
                        color: Colors.white,
                        size: 64,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
