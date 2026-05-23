import 'package:flutter/material.dart';
import 'package:front/core/theme.dart';
import 'package:front/features/homepage/provider/wishlist_provider.dart';
import 'package:front/features/homepage/wishlist_page.dart';
import 'package:provider/provider.dart';

class HomeTopHeader extends StatelessWidget {
  const HomeTopHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final wishlistCount = context.watch<WishlistProvider>().count;

    return Align(
      alignment: Alignment.centerRight,
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const WishlistPage()),
          );
        },
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              height: 56,
              width: 56,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadowLight,
                    blurRadius: 18,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: const Icon(
                Icons.favorite_border_rounded,
                color: AppColors.textDark,
                size: 26,
              ),
            ),
            if (wishlistCount > 0)
              Positioned(
                right: -2,
                top: -2,
                child: Container(
                  height: 22,
                  width: 22,
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '$wishlistCount',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
