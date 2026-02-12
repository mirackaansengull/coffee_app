import 'package:coffee_app/themes/theme.dart';
import 'package:coffee_app/widget/appbar.dart';
import 'package:coffee_app/widget/home_widgets/silderbanner.dart';
import 'package:flutter/material.dart';
import 'package:coffee_app/widget/home_widgets/getlocation.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:coffee_app/widget/home_widgets/Home_Categories.dart';

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
                  return Categories(
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