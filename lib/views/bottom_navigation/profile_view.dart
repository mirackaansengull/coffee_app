import 'package:coffee_app/core/theme/app_theme_colors.dart';
import 'package:coffee_app/data/models/auth_user.dart';
import 'package:coffee_app/data/repositories/order_repository.dart';
import 'package:coffee_app/views/profile_view/all_orders_view.dart';
import 'package:coffee_app/views/profile_view/payment_methods_view.dart';
import 'package:coffee_app/widgets/profile/profile_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({
    super.key,
    required this.user,
    required this.onThemeToggle,
    required this.onLogout,
  });

  final AuthUser user;
  final VoidCallback onThemeToggle;
  final VoidCallback onLogout;

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  @override
  void initState() {
    super.initState();
    OrderRepository.instance.loadOrders();
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppThemeColors.of(context);
    final userName = widget.user.name.isEmpty ? 'Kullanıcı' : widget.user.name;
    final userEmail = widget.user.email;
    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.light
          ? const Color(0xFFFAF8F6)
          : colors.backgroundSecondary,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 24.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  const Spacer(),
                  Text(
                    'Profil',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w700,
                      color: colors.textPrimary,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.notifications_outlined,
                      color: colors.textPrimary,
                      size: 22.sp,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.h),
              Center(
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: colors.accent.withValues(alpha: 0.25),
                      width: 2,
                    ),
                  ),
                  child: CircleAvatar(
                    radius: 46.r,
                    backgroundColor: Colors.transparent,
                    child: CircleAvatar(
                      radius: 44.r,
                      backgroundColor: colors.surfaceDark,
                      child: Icon(
                        Icons.person_rounded,
                        size: 44.sp,
                        color: colors.textHint,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 12.h),
              Text(
                userName,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w700,
                  color: colors.textPrimary,
                  fontFamily: 'Poppins',
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                userEmail,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13.sp,
                  color: colors.textHint,
                  fontFamily: 'Poppins',
                ),
              ),
              SizedBox(height: 18.h),
              ListenableBuilder(
                listenable: OrderRepository.instance,
                builder: (_, __) {
                  final lastOrder = OrderRepository.instance.getLastOrder();
                  return _OrderStatusCard(lastOrder: lastOrder);
                },
              ),
              SizedBox(height: 16.h),
              ProfileTile(
                icon: Icons.receipt_long_rounded,
                title: 'Siparişlerim',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AllOrdersView(),
                    ),
                  );
                },
              ),
              ProfileTile(
                icon: Icons.credit_card_rounded,
                title: 'Ödeme Yöntemleri',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PaymentMethodsView(),
                    ),
                  );
                },
              ),
              ProfileTile(
                icon: Icons.settings_outlined,
                title: 'Ayarlar',
                onTap: () => _showSettingsSheet(context),
              ),
              SizedBox(height: 10.h),
              Divider(color: colors.surfaceBorder.withValues(alpha: 0.6)),
              SizedBox(height: 10.h),
              ProfileTile(
                icon: Icons.logout_rounded,
                title: 'Çıkış Yap',
                onTap: widget.onLogout,
                isDestructive: true,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSettingsSheet(BuildContext context) {
    final colors = AppThemeColors.of(context);
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) {
        final isDark = Theme.of(ctx).brightness == Brightness.dark;
        return Container(
          padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 16.h),
          decoration: BoxDecoration(
            color: colors.backgroundPrimary,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
          ),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Text(
                      'Ayarlar',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                        color: colors.textPrimary,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () => Navigator.pop(ctx),
                      icon: Icon(Icons.close, color: colors.textPrimary),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
                  decoration: BoxDecoration(
                    color: Theme.of(ctx).brightness == Brightness.light
                        ? Colors.white
                        : colors.surfaceDark,
                    borderRadius: BorderRadius.circular(14.r),
                    border: Border.all(
                      color: colors.surfaceBorder.withValues(alpha: 0.5),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.dark_mode_outlined, color: colors.textPrimary),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Text(
                          'Koyu tema',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: colors.textPrimary,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ),
                      Switch(
                        value: isDark,
                        activeColor: colors.accent,
                        onChanged: (_) => widget.onThemeToggle(),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16.h),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _OrderStatusCard extends StatelessWidget {
  const _OrderStatusCard({required this.lastOrder});

  final dynamic lastOrder;

  @override
  Widget build(BuildContext context) {
    final colors = AppThemeColors.of(context);
    final isLight = Theme.of(context).brightness == Brightness.light;

    if (lastOrder == null) {
      return Container(
        padding: EdgeInsets.all(14.w),
        decoration: BoxDecoration(
          color: isLight ? Colors.white : colors.surfaceDark,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: colors.surfaceBorder.withValues(alpha: 0.5)),
          boxShadow: isLight
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Row(
          children: [
            Container(
              width: 44.w,
              height: 44.w,
              decoration: BoxDecoration(
                color: colors.accent.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(
                Icons.local_shipping_outlined,
                color: colors.accent,
                size: 22.sp,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                'Aktif siparişiniz yok',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: colors.textPrimary,
                  fontFamily: 'Poppins',
                ),
              ),
            ),
          ],
        ),
      );
    }

    final int step = (lastOrder.step as int?) ?? 0;
    final statusLabels = const [
      'Onay bekliyor',
      'Hazırlanıyor',
      'Sipariş hazır',
      'Teslim edildi',
    ];
    final stepLabels = const ['Onay', 'Hazırlanıyor', 'Hazır', 'Teslim'];
    final status = statusLabels[step.clamp(0, 3)];

    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: isLight ? Colors.white : colors.surfaceDark,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: colors.surfaceBorder.withValues(alpha: 0.5)),
        boxShadow: isLight
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Sipariş Durumu',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  color: colors.textPrimary,
                  fontFamily: 'Poppins',
                ),
              ),
              const Spacer(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: colors.accent.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: colors.accent,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Text(
            'MEVCUT İLERLEME',
            style: TextStyle(
              fontSize: 11.sp,
              letterSpacing: 0.6,
              fontWeight: FontWeight.w600,
              color: colors.textHint,
              fontFamily: 'Poppins',
            ),
          ),
          SizedBox(height: 10.h),
          _ProgressBar(step: step, accent: colors.accent, bg: colors.surfaceMedium),
          SizedBox(height: 6.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(
              4,
              (i) => Text(
                stepLabels[i],
                style: TextStyle(
                  fontSize: 10.sp,
                  color: colors.textHint,
                  fontFamily: 'Poppins',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProgressBar extends StatelessWidget {
  const _ProgressBar({required this.step, required this.accent, required this.bg});

  final int step;
  final Color accent;
  final Color bg;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(4, (i) {
        final isFilled = i <= step;
        return Expanded(
          child: Container(
            height: 8.h,
            margin: EdgeInsets.only(right: i < 3 ? 4.w : 0),
            decoration: BoxDecoration(
              color: isFilled ? accent : bg.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(999),
            ),
          ),
        );
      }),
    );
  }
}
