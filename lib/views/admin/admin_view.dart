import 'package:coffee_app/core/constants/app_constants.dart';
import 'package:coffee_app/core/theme/app_theme_colors.dart';
import 'package:coffee_app/views/admin/admin_banners_view.dart';
import 'package:coffee_app/views/admin/admin_coffees_view.dart';
import 'package:coffee_app/views/admin/admin_orders_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:coffee_app/data/repositories/bloc/auth_bloc.dart';

class AdminView extends StatelessWidget {
  const AdminView({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppThemeColors.of(context);

    return Scaffold(
      backgroundColor: colors.backgroundPrimary,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 120.h,
            floating: true,
            pinned: true,
            backgroundColor: colors.backgroundPrimary,
            foregroundColor: colors.textPrimary,
            title: Text(
              'Admin Paneli',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w700,
                fontFamily: AppConstants.fontFamily,
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.logout_rounded, size: 24.sp),
                onPressed: () =>
                    context.read<AuthBloc>().add(AuthLogoutRequested()),
                tooltip: 'Çıkış',
              ),
              SizedBox(width: 8.w),
            ],
          ),
          SliverPadding(
            padding: EdgeInsets.fromLTRB(20.w, 24.h, 20.w, 32.h),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Yönetim',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: colors.textHint,
                      fontFamily: AppConstants.fontFamily,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  _AdminMenuCard(
                    icon: Icons.coffee_rounded,
                    title: 'Kahveler',
                    subtitle: 'Kahve ekle, düzenle veya sil',
                    color: const Color(0xFF6D4C41),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const AdminCoffeesView(),
                      ),
                    ),
                  ),
                  SizedBox(height: 14.h),
                  _AdminMenuCard(
                    icon: Icons.receipt_long_rounded,
                    title: 'Siparişler',
                    subtitle: 'Siparişleri görüntüle, durum güncelle',
                    color: const Color(0xFF8D6E63),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const AdminOrdersView(),
                      ),
                    ),
                  ),
                  SizedBox(height: 14.h),
                  _AdminMenuCard(
                    icon: Icons.dashboard_customize_rounded,
                    title: 'Bannerlar',
                    subtitle: 'Ana sayfa banner görsellerini düzenle',
                    color: const Color(0xFF5D4037),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const AdminBannersView(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AdminMenuCard extends StatelessWidget {
  const _AdminMenuCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = AppThemeColors.of(context);

    return Material(
      color: colors.surfaceDark,
      borderRadius: BorderRadius.circular(16.r),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.all(20.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: colors.surfaceBorder, width: 1),
          ),
          child: Row(
            children: [
              Container(
                width: 56.w,
                height: 56.w,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(14.r),
                ),
                child: Icon(icon, color: color, size: 28.sp),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 17.sp,
                        fontWeight: FontWeight.w600,
                        color: colors.textPrimary,
                        fontFamily: AppConstants.fontFamily,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: colors.textHint,
                        fontFamily: AppConstants.fontFamily,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16.sp,
                color: colors.textHint,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
