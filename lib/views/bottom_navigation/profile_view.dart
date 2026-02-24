import 'package:coffee_app/core/theme/app_theme_colors.dart';
import 'package:coffee_app/data/models/auth_user.dart';
import 'package:coffee_app/data/repositories/order_repository.dart';
import 'package:coffee_app/views/profile_view/about_view.dart';
import 'package:coffee_app/views/profile_view/all_orders_view.dart';
import 'package:coffee_app/views/profile_view/help_view.dart';
import 'package:coffee_app/views/profile_view/payment_methods_view.dart';
import 'package:coffee_app/widgets/profile/last_order_card.dart';
import 'package:coffee_app/widgets/profile/orders_section_header.dart';
import 'package:coffee_app/widgets/profile/profile_header.dart';
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
      backgroundColor: colors.backgroundSecondary,
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(gradient: colors.gradientBackground),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(12.w, 20.h, 20.w, 20.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ProfileHeader(
                  userName: userName,
                  userEmail: userEmail,
                  onThemeToggle: widget.onThemeToggle,
                ),
                SizedBox(height: 24.h),
                OrdersSectionHeader(
                  onSeeAllTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AllOrdersView(),
                      ),
                    );
                  },
                ),
                SizedBox(height: 10.h),
                ListenableBuilder(
                  listenable: OrderRepository.instance,
                  builder: (_, __) {
                    final lastOrder = OrderRepository.instance.getLastOrder();
                    if (lastOrder == null) return const SizedBox.shrink();
                    return LastOrderCard(
                      orderStep: lastOrder.step,
                      orderDate: lastOrder.date,
                      orderTime: lastOrder.time,
                    );
                  },
                ),
                SizedBox(height: 20.h),
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
                  icon: Icons.help_outline_rounded,
                  title: 'Yardım',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HelpView(),
                      ),
                    );
                  },
                ),
                ProfileTile(
                  icon: Icons.info_outline_rounded,
                  title: 'Hakkında',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AboutView(),
                      ),
                    );
                  },
                ),
                SizedBox(height: 16.h),
                ProfileTile(
                  icon: Icons.logout_rounded,
                  title: 'Çıkış Yap',
                  onTap: widget.onLogout,
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
