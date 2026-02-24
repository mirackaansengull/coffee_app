import 'package:coffee_app/core/theme/app_theme_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GetLocation extends StatelessWidget {
  const GetLocation({super.key, this.selectedSummary, required this.onTap});

  /// Seçili konum özeti (örn. "Muğla, Menteşe · Aromacafe"). Null ise "Konumunuzu Seçiniz" gösterilir.
  final String? selectedSummary;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = AppThemeColors.of(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(50.r),
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.location_on_outlined,
                size: 20.sp,
                color: colors.textPrimary,
              ),
              SizedBox(width: 8.w),
              Flexible(
                child: Text(
                  selectedSummary ?? 'Konumunuzu Seçiniz',
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    color: colors.textPrimary,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
