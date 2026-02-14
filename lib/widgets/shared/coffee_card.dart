import 'package:coffee_app/core/theme/app_theme_colors.dart';
import 'package:coffee_app/core/theme/app_theme_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CoffeeCard extends StatelessWidget {
  const CoffeeCard({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppThemeColors.of(context);
    return Card(
      elevation: 6,
      shadowColor: Colors.black.withValues(alpha: 0.1),
      margin: EdgeInsets.zero,
      color: colors.backgroundSecondary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.r),
        side: BorderSide(color: colors.surfaceBorder, width: 1),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 3,
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(15.r)),
                    image: const DecorationImage(
                      image: NetworkImage('https://i.lezzet.com.tr/images-800x600/46cb7ac3-c782-4738-bd67-16bc0733ef34-25a66585-419d-4e34-8547-0650bac57d30'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                Positioned(
                  top: 10.h,
                  right: 10.w,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.favorite_border),
                      color: Colors.white,
                      onPressed: () {
                      },
                    ),
                  ),
                ),
              ],
            )
          ),
          SizedBox(height: 8.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
              'Kahve',
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
                color: colors.textPrimary, 
                fontFamily: 'Poppins',
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              '100 TL',
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
                color: colors.textPrimary,
                fontFamily: 'Poppins',
              ),
            ),
              ],
            )
          ),
          SizedBox(height: 4.h),
        ],
      ),
    );
  }
}
