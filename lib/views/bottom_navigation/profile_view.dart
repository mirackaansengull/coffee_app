import 'package:coffee_app/core/theme/theme.dart';
import 'package:coffee_app/views/profile_view/all_orders_view.dart';
import 'package:coffee_app/widgets/profile/last_order_card.dart';
import 'package:coffee_app/widgets/profile/orders_section_header.dart';
import 'package:coffee_app/widgets/profile/profile_header.dart';
import 'package:coffee_app/widgets/profile/profile_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  static const int _profileOrderStep = 1;
  static const String _profileOrderDate = '14.02.2026';
  static const String _profileOrderTime = '12:00';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundSecondary,
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(gradient: AppGradients.background),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(12.w, 20.h, 20.w, 20.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const ProfileHeader(),
                SizedBox(height: 24.h),
                OrdersSectionHeader(
                  onSeeAllTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const AllOrdersView()),
                    );
                  },
                ),
                SizedBox(height: 10.h),
                LastOrderCard(
                  orderStep: _profileOrderStep,
                  orderDate: _profileOrderDate,
                  orderTime: _profileOrderTime,
                ),
                SizedBox(height: 20.h),
                ProfileTile(
                  icon: Icons.credit_card_rounded,
                  title: 'Ödeme Yöntemleri',
                  onTap: () {},
                ),
                ProfileTile(
                  icon: Icons.help_outline_rounded,
                  title: 'Yardım',
                  onTap: () {},
                ),
                ProfileTile(
                  icon: Icons.info_outline_rounded,
                  title: 'Hakkında',
                  onTap: () {},
                ),
                SizedBox(height: 16.h),
                ProfileTile(
                  icon: Icons.logout_rounded,
                  title: 'Çıkış Yap',
                  onTap: () {},
                  isDestructive: true,
                ),
                SizedBox(height: 24.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
