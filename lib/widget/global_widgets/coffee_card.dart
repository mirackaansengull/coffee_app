import 'package:coffee_app/themes/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CoffeeCard extends StatelessWidget {
  const CoffeeCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,

      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      color: AppColors.backgroundSecondary,
      child: Container(
        width: 100.w,
        height: 100.h,
        decoration: BoxDecoration(),
        child: Column(
          children: [
            Image.network(
              'https://i.lezzet.com.tr/images-800x600/46cb7ac3-c782-4738-bd67-16bc0733ef34-25a66585-419d-4e34-8547-0650bac57d30',
              fit: BoxFit.cover,
              width: double.infinity,
              height: 100.h,
            ),
          ],
        ),
      ),
    );
  }
}
