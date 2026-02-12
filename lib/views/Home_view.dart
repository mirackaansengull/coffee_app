import 'package:coffee_app/themes/theme.dart';
import 'package:coffee_app/widget/appbar.dart';
import 'package:coffee_app/widget/global_widgets/coffee_card.dart';
import 'package:coffee_app/widget/home_widgets/silderbanner.dart';
import 'package:flutter/material.dart';
import 'package:coffee_app/widget/home_widgets/getlocation.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:coffee_app/widget/home_widgets/Home_Categories.dart';

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
        decoration: const BoxDecoration(gradient: AppGradients.background),
        child: Column(
          children: [
            Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(50.r),
              child: InkWell(
                borderRadius: BorderRadius.circular(50.r),
                onTap: () {},
                child: GetLocation(),
              ),
            ),
            BannerSlider(),
            SizedBox(height: 16.h),
            SizedBox(
              height: 76.h,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics(),
                ),
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                itemCount: coffeeTypes.length,
                separatorBuilder: (context, index) => SizedBox(width: 12.w),
                itemBuilder: (context, index) {
                  final item = coffeeTypes[index];
                  return Categories(label: item, onTap: () {});
                },
              ),
            ),
            SizedBox(height: 20.h),
            Expanded(
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                itemCount: 10,
                itemBuilder: (context, index) => CoffeeCard(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
