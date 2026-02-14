import 'package:coffee_app/core/theme/app_theme_colors.dart';
import 'package:coffee_app/views/coffee_detail_view.dart';
import 'package:coffee_app/widgets/home/banner_slider.dart';
import 'package:coffee_app/widgets/home/home_categories.dart';
import 'package:coffee_app/widgets/home/location_bar.dart';
import 'package:coffee_app/widgets/shared/coffee_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppThemeColors.of(context);
    return Scaffold(
      backgroundColor: colors.backgroundSecondary,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(gradient: colors.gradientBackground),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
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
                height: 40.h,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  itemCount: coffeeTypes.length,
                  separatorBuilder: (context, index) => SizedBox(width: 12.w),
                  itemBuilder: (context, index) {
                    final category = coffeeTypes[index];
                    return Categories(
                      icon: category.icon,
                      label: category.label,
                      onTap: () {},
                    );
                  },
                ),
              ),
              SizedBox(height: 20.h),
              InkWell(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => CoffeeDetail()));
                },
                child: Padding(
                  padding: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 20.h),
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12.w,
                      mainAxisSpacing: 12.h,
                      childAspectRatio: 0.72,
                    ),
                    itemCount: 10,
                    itemBuilder: (context, index) => const CoffeeCard(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
