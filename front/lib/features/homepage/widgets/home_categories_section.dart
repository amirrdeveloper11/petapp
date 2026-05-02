import 'package:flutter/material.dart';
import 'package:front/core/theme.dart';
import 'package:front/features/homepage/models/category_model.dart';
import 'package:front/features/homepage/service/app_network_image.dart';

class HomeCategoriesSection extends StatelessWidget {
  final List<CategoryModel> categories;
  final VoidCallback onSeeAll;
  final ValueChanged<int> onCategoryTap;

  const HomeCategoriesSection({
    super.key,
    required this.categories,
    required this.onSeeAll,
    required this.onCategoryTap,
  });

  @override
  Widget build(BuildContext context) {
    if (categories.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Header(
          title: 'Categories',
          actionText: 'See all',
          onActionTap: onSeeAll,
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 98,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final category = categories[index];

              return GestureDetector(
                onTap: () => onCategoryTap(category.id),
                child: Container(
                  width: 92,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: AppColors.softBackground,
                          shape: BoxShape.circle,
                        ),
                        child: ClipOval(
                          child:
                              category.imageUrl != null &&
                                  category.imageUrl!.trim().isNotEmpty
                              ? AppNetworkImage(
                                  url: category.imageUrl,
                                  fit: BoxFit.cover,
                                  errorWidget: const Icon(
                                    Icons.category_outlined,
                                    size: 22,
                                  ),
                                )
                              : const Icon(Icons.category_outlined, size: 22),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        category.name,
                        maxLines: 2,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _Header extends StatelessWidget {
  final String title;
  final String actionText;
  final VoidCallback onActionTap;

  const _Header({
    required this.title,
    required this.actionText,
    required this.onActionTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
        ),
        InkWell(
          onTap: onActionTap,
          borderRadius: BorderRadius.circular(8),
          child: const Padding(
            padding: EdgeInsets.all(4),
            child: Text(
              'See all',
              style: TextStyle(
                color: AppColors.primaryGreen,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
