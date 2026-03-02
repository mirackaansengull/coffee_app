import 'package:coffee_app/core/constants/asset_paths.dart';
import 'package:coffee_app/core/theme/app_theme_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CategoryItem {
  const CategoryItem({required this.label, required this.icon});
  final String label;
  final ImageIcon icon;
}

const List<CategoryItem> coffeeTypes = [
  CategoryItem(
    label: 'En Çok Satanlar',
    icon: ImageIcon(AssetImage(AssetPaths.categoryEnCokSatanlar)),
  ),
  CategoryItem(
    label: 'Sıcak Kahve',
    icon: ImageIcon(AssetImage(AssetPaths.categorySicakKahve)),
  ),
  CategoryItem(
    label: 'Sıcak Kahveler',
    icon: ImageIcon(AssetImage(AssetPaths.categorySicakKahve)),
  ),
  CategoryItem(
    label: 'Soğuk Kahve',
    icon: ImageIcon(AssetImage(AssetPaths.categorySogukKahve)),
  ),
  CategoryItem(
    label: 'Filtre Kahve',
    icon: ImageIcon(AssetImage(AssetPaths.categoryFiltreKahve)),
  ),
  CategoryItem(
    label: 'Espresso',
    icon: ImageIcon(AssetImage(AssetPaths.categoryEspresso)),
  ),
  CategoryItem(
    label: 'Türk Kahvesi',
    icon: ImageIcon(AssetImage(AssetPaths.categoryTurkKahvesi)),
  ),
  CategoryItem(
    label: 'Latte',
    icon: ImageIcon(AssetImage(AssetPaths.categoryLatte)),
  ),
];

class Categories extends StatelessWidget {
  const Categories({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.isSelected = false,
  });

  final ImageIcon icon;
  final String label;
  final VoidCallback onTap;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final colors = AppThemeColors.of(context);
    final isLight = Theme.of(context).brightness == Brightness.light;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.r),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
          decoration: BoxDecoration(
            color: isSelected
                ? colors.accent
                : (isLight ? Colors.white : colors.surfaceDark),
            borderRadius: BorderRadius.circular(12.r),
            border: isSelected
                ? null
                : Border.all(color: colors.surfaceBorder, width: 1),
            boxShadow: isLight && !isSelected
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.06),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isSelected)
                ColorFiltered(
                  colorFilter: const ColorFilter.mode(
                    Colors.white,
                    BlendMode.srcIn,
                  ),
                  child: Image(
                    image: icon.image!,
                    width: 20.w,
                    height: 20.w,
                    fit: BoxFit.contain,
                  ),
                )
              else
                Image(
                  image: icon.image!,
                  width: 20.w,
                  height: 20.w,
                  fit: BoxFit.contain,
                ),
              SizedBox(width: 8.w),
              Flexible(
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w500,
                    color: isSelected
                        ? Colors.white
                        : colors.textPrimary,
                    fontFamily: 'Poppins',
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
