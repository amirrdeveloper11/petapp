import 'package:flutter/material.dart';
import '../../../core/theme.dart';
import '../../homepage/models/category_model.dart';
import '../../homepage/service/app_network_image.dart';

class StoreCategoryChips extends StatelessWidget {
  final List<CategoryModel> categories;
  final int? selectedCategoryId;
  final ValueChanged<int> onSelected;

  const StoreCategoryChips({
    super.key,
    required this.categories,
    required this.selectedCategoryId,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    if (categories.isEmpty) return const SizedBox.shrink();

    return SizedBox(
      height: 98,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final category = categories[index];
          final selected = category.id == selectedCategoryId;

          return GestureDetector(
            onTap: () => onSelected(category.id),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 92,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.ivory,
                borderRadius: BorderRadius.circular(AppRadii.lg),
                border: Border.all(
                  color: selected ? AppColors.deepTeal : AppColors.hairline,
                  width: selected ? 1.4 : 1,
                ),
                boxShadow: AppShadows.soft,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: selected ? AppColors.deepTeal : AppColors.tealSoft,
                      shape: BoxShape.circle,
                    ),
                    child: ClipOval(
                      child:
                          category.imageUrl != null &&
                              category.imageUrl!.trim().isNotEmpty
                          ? AppNetworkImage(
                              url: category.imageUrl,
                              fit: BoxFit.cover,
                              errorWidget: Icon(
                                Icons.category_outlined,
                                size: 22,
                                color: selected
                                    ? Colors.white
                                    : AppColors.teal,
                              ),
                            )
                          : Icon(
                              Icons.category_outlined,
                              size: 22,
                              color: selected ? Colors.white : AppColors.teal,
                            ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    category.name,
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w700,
                      color: selected
                          ? AppColors.deepTeal
                          : AppColors.textPrimary,
                      height: 1.15,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
