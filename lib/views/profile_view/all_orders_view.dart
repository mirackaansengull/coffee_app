import 'package:coffee_app/core/constants/app_constants.dart';
import 'package:coffee_app/core/constants/order_constants.dart';
import 'package:coffee_app/core/theme/app_theme_colors.dart';
import 'package:coffee_app/data/repositories/order_repository.dart';
import 'package:coffee_app/data/models/order.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AllOrdersView extends StatefulWidget {
  const AllOrdersView({super.key});

  @override
  State<AllOrdersView> createState() => _AllOrdersViewState();
}

class _AllOrdersViewState extends State<AllOrdersView> {
  @override
  void initState() {
    super.initState();
    OrderRepository.instance.loadOrders();
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppThemeColors.of(context);
    return Scaffold(
      backgroundColor: colors.backgroundPrimary,
      appBar: AppBar(
        backgroundColor: colors.backgroundPrimary,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 20.sp,
            color: colors.textPrimary,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Tüm Siparişler',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: colors.textPrimary,
            fontFamily: AppConstants.fontFamily,
          ),
        ),
        centerTitle: true,
      ),
      body: ListenableBuilder(
        listenable: OrderRepository.instance,
        builder: (context, _) {
          final orders = OrderRepository.instance.getOrders();
          if (orders.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.receipt_long_outlined, size: 64.sp, color: colors.textHint),
                  SizedBox(height: 16.h),
                  Text(
                    'Henüz siparişiniz yok',
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: colors.textHint,
                      fontFamily: AppConstants.fontFamily,
                    ),
                  ),
                ],
              ),
            );
          }
          return ListView.builder(
            padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 24.h),
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              return _OrderCard(
                order: order,
                statuses: OrderConstants.statusLabels,
              );
            },
          );
        },
      ),
    );
  }
}

class _OrderCard extends StatefulWidget {
  const _OrderCard({required this.order, required this.statuses});

  final Order order;
  final List<String> statuses;

  @override
  State<_OrderCard> createState() => _OrderCardState();
}

class _OrderCardState extends State<_OrderCard> {
  bool _expanded = false;
  late int _rating;

  @override
  void initState() {
    super.initState();
    _rating = widget.order.rating;
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppThemeColors.of(context);
    const orange = Color(0xFFFF9800);
    final order = widget.order;
    final step = order.step.clamp(0, widget.statuses.length - 1);
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: colors.surfaceDark,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: colors.surfaceBorder, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => setState(() => _expanded = !_expanded),
          borderRadius: BorderRadius.circular(12.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${order.date} · ${order.time}',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: colors.textHint,
                            fontFamily: AppConstants.fontFamily,
                          ),
                        ),
                        Icon(
                          _expanded
                              ? Icons.keyboard_arrow_up_rounded
                              : Icons.keyboard_arrow_down_rounded,
                          size: 22.sp,
                          color: colors.textHint,
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      widget.statuses[step],
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
              color: orange,
              fontFamily: AppConstants.fontFamily,
            ),
          ),
          if (order.items.isNotEmpty) ...[
            SizedBox(height: 4.h),
            Text(
              order.items.map((e) => '${e.name} x${e.quantity}').join(', '),
              style: TextStyle(
                fontSize: 12.sp,
                color: colors.textHint,
                fontFamily: AppConstants.fontFamily,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
          SizedBox(height: 14.h),
          Row(
            children: List.generate(4, (i) {
              final isFilled = i <= order.step;
              return Expanded(
                child: Container(
                  height: 6.h,
                  margin: EdgeInsets.only(right: i < 3 ? 2.w : 0),
                  decoration: BoxDecoration(
                    color: isFilled ? orange : colors.surfaceMedium,
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
                ...OrderConstants.stepLabels.map(
                  (label) => Text(
                    label,
                    style: TextStyle(
                      fontSize: 9.sp,
                      color: colors.textHint,
                      fontFamily: AppConstants.fontFamily,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (order.step == 3 && !_expanded) ...[
            SizedBox(height: 16.h),
            Text(
              '5 yıldız üzerinden puan verin',
              style: TextStyle(
                fontSize: 12.sp,
                color: colors.textHint,
                fontFamily: AppConstants.fontFamily,
              ),
            ),
            SizedBox(height: 8.h),
            Row(
              children: List.generate(5, (i) {
                final star = i + 1;
                final selected = _rating >= star;
                return Padding(
                  padding: EdgeInsets.only(right: 4.w),
                  child: InkWell(
                    onTap: () => setState(() => _rating = star),
                    borderRadius: BorderRadius.circular(8.r),
                    child: Icon(
                      selected
                          ? Icons.star_rounded
                          : Icons.star_outline_rounded,
                      size: 26.sp,
                      color: selected ? orange : colors.textHint,
                    ),
                  ),
                );
              }),
            ),
          ],
                  ],
                ),
              ),
              if (_expanded) ...[
                Divider(height: 1, color: colors.surfaceBorder),
                Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Sipariş detayı',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: colors.textPrimary,
                          fontFamily: AppConstants.fontFamily,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      ...order.items.map((item) {
                        return Padding(
                          padding: EdgeInsets.only(bottom: 10.h),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${item.name} x${item.quantity} · ${item.totalPrice} TL',
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w600,
                                  color: colors.textPrimary,
                                  fontFamily: AppConstants.fontFamily,
                                ),
                              ),
                              SizedBox(height: 2.h),
                              Text(
                                item.optionsSummary,
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: colors.textHint,
                                  fontFamily: AppConstants.fontFamily,
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                      if (order.delivery != null) ...[
                        SizedBox(height: 12.h),
                        Text(
                          'Teslimat: ${order.delivery!.summary}',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: colors.textHint,
                            fontFamily: AppConstants.fontFamily,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          order.delivery!.address,
                          style: TextStyle(
                            fontSize: 11.sp,
                            color: colors.textHint,
                            fontFamily: AppConstants.fontFamily,
                          ),
                        ),
                      ],
                      SizedBox(height: 12.h),
                      Text(
                        'Toplam: ${order.total} TL',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700,
                          color: colors.textPrimary,
                          fontFamily: AppConstants.fontFamily,
                        ),
                      ),
                      if (order.step == 3) ...[
                        SizedBox(height: 16.h),
                        Text(
                          '5 yıldız üzerinden puan verin',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: colors.textHint,
                            fontFamily: AppConstants.fontFamily,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Row(
                          children: List.generate(5, (i) {
                            final star = i + 1;
                            final selected = _rating >= star;
                            return Padding(
                              padding: EdgeInsets.only(right: 4.w),
                              child: InkWell(
                                onTap: () => setState(() => _rating = star),
                                borderRadius: BorderRadius.circular(8.r),
                                child: Icon(
                                  selected
                                      ? Icons.star_rounded
                                      : Icons.star_outline_rounded,
                                  size: 26.sp,
                                  color: selected ? orange : colors.textHint,
                                ),
                              ),
                            );
                          }),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
