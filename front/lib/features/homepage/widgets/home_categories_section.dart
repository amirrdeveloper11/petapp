import 'package:flutter/material.dart';
import 'package:front/core/theme.dart';
import 'package:front/features/homepage/models/category_model.dart';
import 'package:front/features/homepage/service/app_network_image.dart';
import 'package:front/features/homepage/widgets/home_section_header.dart';

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
        HomeSectionHeader(
          title: 'Shop by Category',
          subtitle: 'Curated essentials for every pet',
          leadingIcon: Icons.grid_view_rounded,
          onActionTap: onSeeAll,
        ),
        const SizedBox(height: 14),
        SizedBox(
          height: 104,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final category = categories[index];

              return GestureDetector(
                onTap: () => onCategoryTap(category.id),
                child: Container(
                  width: 88,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.ivory,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.hairline, width: 1),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.shadowLight,
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 46,
                        height: 46,
                        decoration: const BoxDecoration(
                          color: AppColors.tealSoft,
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
                                    size: 20,
                                    color: AppColors.teal,
                                  ),
                                )
                              : const Icon(
                                  Icons.category_outlined,
                                  size: 20,
                                  color: AppColors.teal,
                                ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        category.name,
                        maxLines: 2,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                          height: 1.15,
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
