import 'package:coffee_app/core/constants/asset_paths.dart';
import 'package:coffee_app/core/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CategoryItem {
  const CategoryItem({required this.label, required this.icon});
  final String label;
  final ImageIcon icon;
}

const List<CategoryItem> coffeeTypes = [
  CategoryItem(label: 'En Çok Satanlar', icon: ImageIcon(AssetImage(AssetPaths.categoryEnCokSatanlar))),
  CategoryItem(label: 'Sıcak Kahve', icon: ImageIcon(AssetImage(AssetPaths.categorySicakKahve))),
  CategoryItem(label: 'Soğuk Kahve', icon: ImageIcon(AssetImage(AssetPaths.categorySogukKahve))),
  CategoryItem(label: 'Filtre Kahve', icon: ImageIcon(AssetImage(AssetPaths.categoryFiltreKahve))),
  CategoryItem(label: 'Espresso', icon: ImageIcon(AssetImage(AssetPaths.categoryEspresso))),
  CategoryItem(label: 'Türk Kahvesi', icon: ImageIcon(AssetImage(AssetPaths.categoryTurkKahvesi))),
  CategoryItem(label: 'Latte', icon: ImageIcon(AssetImage(AssetPaths.categoryLatte))),
];

class Categories extends StatelessWidget {
  const Categories({super.key, required this.icon, required this.label, required this.onTap});

  final ImageIcon icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(7.r),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 61, 35, 32),
            borderRadius: BorderRadius.circular(7.r),
            border: Border.all(color: AppColors.surfaceDark, width: 1),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ImageIcon(
                icon.image,
                size: 18.sp,
                color: AppColors.textPrimary,
              ),
              SizedBox(width: 6.w),
              Flexible(
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                    fontFamily: 'Poppins',
                  ),
                  maxLines: 2,
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
