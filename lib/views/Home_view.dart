import 'package:coffee_app/themes/theme.dart';
import 'package:coffee_app/widget/appbar.dart';
import 'package:coffee_app/widget/silderbanner.dart';
import 'package:flutter/material.dart';
import 'package:coffee_app/widget/getlocation.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

const List<String> _coffeeTypes = [
  'Sıcak Kahve',
  'Soğuk Kahve',
  'Filtre Kahve',
  'Espresso',
  'Türk Kahvesi',
  'Latte',
];

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundSecondary,
      appBar: Appbar(),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: AppGradients.background,
        ),
        child: Column(
          children: [
            Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(50.r),
              child: InkWell(
                borderRadius: BorderRadius.circular(50.r),
                onTap: (){}, 
                child: GetLocation()
                ),
              ),   
            BannerSlider(),
            SizedBox(height: 16.h),
            SizedBox(
              height: 40.h,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                itemCount: _coffeeTypes.length,
                separatorBuilder: (_, __) => SizedBox(width: 12.w),
                itemBuilder: (context, index) {
                  final item = _coffeeTypes[index];
                  return _CoffeeTypeChip(
                    label: item,
                    onTap: () {},
                  );
                },
              ),
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }
}

class _CoffeeTypeChip extends StatelessWidget {
  const _CoffeeTypeChip({required this.label, required this.onTap});

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
          width: 100.w,
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 61, 35, 32),
            borderRadius: BorderRadius.circular(7.r),
            border: Border.all(color: AppColors.surfaceDark, width: 1),
          ),
          child: Center(
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
        ),
      ),
    );
  }
}