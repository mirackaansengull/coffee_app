import 'package:coffee_app/core/constants/app_constants.dart';
import 'package:coffee_app/core/constants/order_constants.dart';
import 'package:coffee_app/core/theme/app_theme_colors.dart';
import 'package:coffee_app/data/models/order.dart';
import 'package:coffee_app/data/repositories/order_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AdminOrdersView extends StatelessWidget {
  const AdminOrdersView({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppThemeColors.of(context);
    final orders = OrderRepository.instance.getOrders();

    return Scaffold(
      backgroundColor: colors.backgroundPrimary,
      appBar: AppBar(
        title: Text(
          'Siparişler',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            fontFamily: AppConstants.fontFamily,
          ),
        ),
        backgroundColor: colors.backgroundPrimary,
        foregroundColor: colors.textPrimary,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, size: 20.sp),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: orders.isEmpty
          ? Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 32.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.receipt_long_rounded,
                      size: 72.sp,
                      color: colors.textHint,
                    ),
                    SizedBox(height: 20.h),
                    Text(
                      'Henüz sipariş yok',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                        color: colors.textPrimary,
                        fontFamily: AppConstants.fontFamily,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'Müşteri siparişleri burada listelenecek.\nDurumlar: Onay bekliyor → Hazırlanıyor → Sipariş hazır → Teslim edildi',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: colors.textHint,
                        fontFamily: AppConstants.fontFamily,
                        height: 1.4,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            )
          : ListView.builder(
              padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 24.h),
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                return _AdminOrderCard(
                  order: order,
                  statuses: OrderConstants.statusLabels,
                );
              },
            ),
    );
  }
}

class _AdminOrderCard extends StatelessWidget {
  const _AdminOrderCard({
    required this.order,
    required this.statuses,
  });

  final Order order;
  final List<String> statuses;

  @override
  Widget build(BuildContext context) {
    final colors = AppThemeColors.of(context);
    final step = order.step.clamp(0, statuses.length - 1);

    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 14.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: colors.surfaceDark,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: colors.surfaceBorder, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Sipariş #${order.id.substring(0, order.id.length > 8 ? 8 : order.id.length)}',
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w700,
                  color: colors.textPrimary,
                  fontFamily: AppConstants.fontFamily,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: _statusColor(step).withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  statuses[step],
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: _statusColor(step),
                    fontFamily: AppConstants.fontFamily,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            '${order.date} · ${order.time}',
            style: TextStyle(
              fontSize: 13.sp,
              color: colors.textHint,
              fontFamily: AppConstants.fontFamily,
            ),
          ),
          SizedBox(height: 14.h),
          Row(
            children: List.generate(
              statuses.length,
              (i) {
                final isFilled = i <= order.step;
                return Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 4.h,
                          decoration: BoxDecoration(
                            color: isFilled
                                ? _statusColor(order.step)
                                : colors.surfaceBorder,
                            borderRadius: BorderRadius.horizontal(
                              left: Radius.circular(i == 0 ? 2.r : 0),
                              right: Radius.circular(
                                  i == statuses.length - 1 ? 2.r : 0),
                            ),
                          ),
                        ),
                      ),
                      if (i < statuses.length - 1) SizedBox(width: 2.w),
                    ],
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 8.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: statuses.asMap().entries.map((e) {
              final i = e.key;
              final label = e.value;
              final isActive = i == order.step;
              return Text(
                label,
                style: TextStyle(
                  fontSize: 10.sp,
                  color: isActive
                      ? _statusColor(order.step)
                      : colors.textHint,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                  fontFamily: AppConstants.fontFamily,
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Color _statusColor(int step) {
    switch (step) {
      case 0:
        return const Color(0xFFFF9800);
      case 1:
        return const Color(0xFF2196F3);
      case 2:
        return const Color(0xFF8BC34A);
      case 3:
        return const Color(0xFF4CAF50);
      default:
        return const Color(0xFFFF9800);
    }
  }
}
