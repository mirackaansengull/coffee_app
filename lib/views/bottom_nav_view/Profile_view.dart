import 'package:coffee_app/themes/theme.dart';
import 'package:coffee_app/views/bottom_nav_view/profile_views/All_orders_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  static const List<String> _orderStatuses = [
    'Onay bekliyor',
    'Hazırlanıyor',
    'Sipariş hazır',
    'Teslim edildi',
  ];

  static const int _profileOrderStep = 1;
  static const String _profileOrderDate = '14.02.2026';
  static const String _profileOrderTime = '12:00';
  int _orderRating = 0;

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
                SizedBox(height: 8.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.notifications_outlined,
                        size: 24.sp,
                        color: AppColors.textPrimary,
                      ),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
                    ),
                  ],
                ),
                Center(
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 36.r,
                        backgroundColor: AppColors.surfaceDark,
                        child: Icon(
                          Icons.person_rounded,
                          size: 38.sp,
                          color: AppColors.textHint,
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Text(
                        'Kullanıcı Adı',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        'kullanici@email.com',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: AppColors.textHint,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24.h),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 8.w),
                      child: Text(
                        'Siparişlerim',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const AllOrdersView()),
                        );
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Tüm siparişler',
                            style: TextStyle(
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w300,
                              color: AppColors.textPrimary,
                              fontFamily: 'Poppins',
                            ),
                          ),
                          SizedBox(width: 4.w),
                          Icon(
                            Icons.chevron_right_rounded,
                            size: 18.sp,
                            color: AppColors.textPrimary,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10.h),
                _lastOrderCard(),
                SizedBox(height: 20.h),
                _profileTile(
                  icon: Icons.credit_card_rounded,
                  title: 'Ödeme Yöntemleri',
                  onTap: () {},
                ),
                _profileTile(
                  icon: Icons.help_outline_rounded,
                  title: 'Yardım',
                  onTap: () {},
                ),
                _profileTile(
                  icon: Icons.info_outline_rounded,
                  title: 'Hakkında',
                  onTap: () {},
                ),
                SizedBox(height: 16.h),
                _profileTile(
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

  Widget _lastOrderCard() {
    const orange = Color(0xFFFF9800);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.surfaceMedium, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Son sipariş',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                  fontFamily: 'Poppins',
                ),
              ),
              Text(
                '$_profileOrderDate · $_profileOrderTime',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: AppColors.textHint,
                  fontFamily: 'Poppins',
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            _orderStatuses[_profileOrderStep],
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
              color: orange,
              fontFamily: 'Poppins',
            ),
          ),
          SizedBox(height: 14.h),
          Row(
            children: List.generate(4, (i) {
              final isFilled = i <= _profileOrderStep;
              return Expanded(
                child: Container(
                  height: 6.h,
                  margin: EdgeInsets.only(right: i < 3 ? 2.w : 0),
                  decoration: BoxDecoration(
                    color: isFilled ? orange : AppColors.surfaceMedium,
                    borderRadius: BorderRadius.horizontal(
                      left: Radius.circular(i == 0 ? 3.r : 0),
                      right: Radius.circular(i == 3 ? 3.r : 0),
                    ),
                  ),
                ),
              );
            }),
          ),
          SizedBox(height: 6.h),
          Padding(
            padding: EdgeInsets.only(top: 4.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Onay',
                  style: TextStyle(fontSize: 9.sp, color: AppColors.textHint, fontFamily: 'Poppins'),
                ),
                Text(
                  'Hazırlanıyor',
                  style: TextStyle(fontSize: 9.sp, color: AppColors.textHint, fontFamily: 'Poppins'),
                ),
                Text(
                  'Hazır',
                  style: TextStyle(fontSize: 9.sp, color: AppColors.textHint, fontFamily: 'Poppins'),
                ),
                Text(
                  'Teslim',
                  style: TextStyle(fontSize: 9.sp, color: AppColors.textHint, fontFamily: 'Poppins'),
                ),
              ],
            ),
          ),
          if (_profileOrderStep == 3) ...[
            SizedBox(height: 16.h),
            Text(
              '5 yıldız üzerinden puan verin',
              style: TextStyle(
                fontSize: 12.sp,
                color: AppColors.textHint,
                fontFamily: 'Poppins',
              ),
            ),
            SizedBox(height: 8.h),
            Row(
              children: List.generate(5, (i) {
                final star = i + 1;
                final selected = _orderRating >= star;
                return Padding(
                  padding: EdgeInsets.only(right: 4.w),
                  child: InkWell(
                    onTap: () => setState(() => _orderRating = star),
                    borderRadius: BorderRadius.circular(8.r),
                    child: Icon(
                      selected ? Icons.star_rounded : Icons.star_outline_rounded,
                      size: 28.sp,
                      color: selected ? orange : AppColors.textHint,
                    ),
                  ),
                );
              }),
            ),
          ],
        ],
      ),
    );
  }

  Widget _profileTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    final color = isDestructive ? Colors.red.shade300 : AppColors.textPrimary;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10.r),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 14.w),
          margin: EdgeInsets.only(bottom: 4.h),
          decoration: BoxDecoration(
            color: AppColors.surfaceDark,
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(color: AppColors.surfaceMedium, width: 1),
          ),
          child: Row(
            children: [
              Icon(icon, size: 20.sp, color: color),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w500,
                    color: color,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                size: 20.sp,
                color: AppColors.textHint,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
