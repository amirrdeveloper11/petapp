import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:front/core/theme.dart';
import 'package:front/features/auth/user/provider/user_provider.dart';
import 'package:front/features/homepage/provider/wishlist_provider.dart';
import 'package:front/features/homepage/wishlist_page.dart';
import 'package:front/features/petcrud/provider/pet_provider.dart';

class HomeHeroHeader extends StatelessWidget {
  const HomeHeroHeader({super.key});

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().user;
    final petsCount = context.watch<PetProvider>().pets.length;
    final wishlistCount = context.watch<WishlistProvider>().count;

    final fullName = (user?.fullName ?? '').trim();
    final firstName = fullName.isEmpty
        ? 'Pet Parent'
        : fullName.split(RegExp(r'\s+')).first;

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final isSmall = width < 350;
        final isMedium = width >= 350 && width < 420;

        final height = isSmall
            ? 245.0
            : isMedium
            ? 258.0
            : 270.0;

        final horizontalPadding = isSmall
            ? 16.0
            : isMedium
            ? 18.0
            : 22.0;

        final topPadding = isSmall ? 14.0 : 18.0;
        final titleSize = isSmall
            ? 18.0
            : isMedium
            ? 20.0
            : 21.0;

        final avatarSize = isSmall ? 46.0 : 50.0;
        final actionSize = isSmall ? 42.0 : 44.0;

        return SizedBox(
          width: double.infinity,
          height: height,
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(36),
              bottomRight: Radius.circular(36),
            ),
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: AppColors.heroGradient,
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: -60,
                    right: -40,
                    child: _Blob(size: 190, opacity: 0.14),
                  ),
                  Positioned(
                    bottom: -70,
                    left: -50,
                    child: _Blob(size: 170, opacity: 0.10),
                  ),
                  Positioned(
                    top: 38,
                    left: -24,
                    child: Icon(
                      Icons.pets_rounded,
                      size: 90,
                      color: Colors.white.withOpacity(0.05),
                    ),
                  ),
                  SafeArea(
                    bottom: false,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(
                        horizontalPadding,
                        topPadding,
                        horizontalPadding,
                        24,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: avatarSize,
                                height: avatarSize,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white.withOpacity(0.14),
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.35),
                                    width: 1.4,
                                  ),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  firstName.isNotEmpty
                                      ? firstName[0].toUpperCase()
                                      : 'W',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: isSmall ? 18 : 20,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _greeting(),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.78),
                                        fontSize: isSmall ? 11.5 : 12.5,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      firstName,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: isSmall ? 19 : 21,
                                        fontWeight: FontWeight.w800,
                                        letterSpacing: -0.3,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              _CircleIconButton(
                                size: actionSize,
                                icon: Icons.favorite_rounded,
                                badgeCount: wishlistCount,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const WishlistPage(),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                          const Spacer(),
                          Text(
                            'Everything your pet needs,',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: titleSize,
                              height: 1.15,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.35,
                            ),
                          ),
                          Text(
                            'in one trusted place.',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.94),
                              fontSize: titleSize,
                              height: 1.15,
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.35,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Icon(
                                Icons.pets_rounded,
                                size: 15,
                                color: AppColors.goldLight,
                              ),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  petsCount > 0
                                      ? '$petsCount ${petsCount == 1 ? 'pet' : 'pets'} under Pawpal care'
                                      : 'Add your first pet to get started',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.85),
                                    fontSize: isSmall ? 11 : 12.5,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  final IconData icon;
  final int badgeCount;
  final VoidCallback onTap;
  final double size;

  const _CircleIconButton({
    required this.icon,
    required this.badgeCount,
    required this.onTap,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: SizedBox(
        width: size + 8,
        height: size + 8,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.14),
                border: Border.all(
                  color: Colors.white.withOpacity(0.32),
                  width: 1.2,
                ),
              ),
              child: Icon(icon, color: Colors.white, size: size * 0.46),
            ),
            if (badgeCount > 0)
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  height: 18,
                  width: 18,
                  decoration: BoxDecoration(
                    color: AppColors.gold,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.deepTeal, width: 1.5),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    badgeCount > 9 ? '9+' : '$badgeCount',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 9,
                      fontWeight: FontWeight.w800,
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

class _Blob extends StatelessWidget {
  final double size;
  final double opacity;

  const _Blob({required this.size, required this.opacity});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withOpacity(opacity),
      ),
    );
  }
}
