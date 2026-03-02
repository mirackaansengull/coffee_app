import 'package:coffee_app/core/theme/app_theme_colors.dart';
import 'package:coffee_app/data/models/coffee.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CoffeeCard extends StatelessWidget {
  const CoffeeCard({
    super.key,
    required this.coffee,
    this.onTap,
    this.onFavoriteTap,
    this.onAddToCart,
    this.isFavorite = false,
  });

  final Coffee coffee;
  final VoidCallback? onTap;
  final VoidCallback? onFavoriteTap;
  final VoidCallback? onAddToCart;
  final bool isFavorite;

  /// Rating gösterimi için (veri yoksa 4.5–4.9 arası sabit)
  double get _rating => 4.5 + (coffee.name.hashCode % 5) / 10;

  @override
  Widget build(BuildContext context) {
    final colors = AppThemeColors.of(context);
    final isLight = Theme.of(context).brightness == Brightness.light;
    final accent = colors.accent;

    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      color: isLight ? Colors.white : colors.surfaceDark,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
        side: BorderSide(
          color: colors.surfaceBorder.withValues(alpha: 0.5),
          width: 1,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 3,
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(12.r),
                      ),
                      image: DecorationImage(
                        image: NetworkImage(coffee.imageUrl),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 8.h,
                    right: 8.w,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 5.w,
                        vertical: 3.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.star_rounded,
                            size: 11.sp,
                            color: Colors.amber.shade400,
                          ),
                          SizedBox(width: 3.w),
                          Text(
                            _rating.toStringAsFixed(1),
                            style: TextStyle(
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(10.w, 8.h, 10.w, 10.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    coffee.name,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: colors.textPrimary,
                      fontFamily: 'Poppins',
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (coffee.description != null &&
                      coffee.description!.isNotEmpty) ...[
                    SizedBox(height: 4.h),
                    Text(
                      coffee.description!,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: colors.textHint,
                        fontFamily: 'Poppins',
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  SizedBox(height: 10.h),
                  Row(
                    children: [
                      Text(
                        '${coffee.price} TL',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700,
                          color: accent,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      const Spacer(),
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: onAddToCart != null
                              ? () => onAddToCart!()
                              : onTap,
                          borderRadius: BorderRadius.circular(10.r),
                          child: Container(
                            width: 36.w,
                            height: 36.w,
                            decoration: BoxDecoration(
                              color: accent,
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            child: Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 22.sp,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
