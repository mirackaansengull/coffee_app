import 'package:coffee_app/core/constants/app_constants.dart';
import 'package:coffee_app/core/constants/order_constants.dart';
import 'package:coffee_app/core/theme/app_theme_colors.dart';
import 'package:coffee_app/data/models/order.dart';
import 'package:coffee_app/data/repositories/order_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AdminOrdersView extends StatefulWidget {
  const AdminOrdersView({super.key});

  @override
  State<AdminOrdersView> createState() => _AdminOrdersViewState();
}

class _AdminOrdersViewState extends State<AdminOrdersView> {
  final _repo = OrderRepository.instance;

  @override
  void initState() {
    super.initState();
    _repo.loadAdminOrders();
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppThemeColors.of(context);
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
      body: ListenableBuilder(
        listenable: _repo,
        builder: (context, _) {
          final orders = _repo.getAdminOrders();
          if (orders.isEmpty) {
            return Center(
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
                      'Müşteri siparişleri burada listelenecek.',
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
            );
          }
          return ListView.builder(
            padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 24.h),
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              return _AdminOrderExpandableCard(
                order: order,
                statuses: OrderConstants.statusLabels,
                onStatusChanged: (newStatus) async {
                  final ok = await _repo.updateOrderStatus(order.id, newStatus);
                  if (mounted && !ok) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Durum güncellenemedi')),
                    );
                  }
                },
              );
            },
          );
        },
      ),
    );
  }
}

class _AdminOrderExpandableCard extends StatefulWidget {
  const _AdminOrderExpandableCard({
    required this.order,
    required this.statuses,
    required this.onStatusChanged,
  });

  final Order order;
  final List<String> statuses;
  final ValueChanged<int> onStatusChanged;

  @override
  State<_AdminOrderExpandableCard> createState() =>
      _AdminOrderExpandableCardState();
}

class _AdminOrderExpandableCardState extends State<_AdminOrderExpandableCard> {
  bool _expanded = false;

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

  @override
  Widget build(BuildContext context) {
    final colors = AppThemeColors.of(context);
    final order = widget.order;
    final statuses = widget.statuses;
    final step = order.step.clamp(0, statuses.length - 1);
    final shortId =
        order.id.length > 8 ? order.id.substring(0, 8) : order.id;

    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 14.h),
      decoration: BoxDecoration(
        color: colors.surfaceDark,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: colors.surfaceBorder, width: 1),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => setState(() => _expanded = !_expanded),
          borderRadius: BorderRadius.circular(14.r),
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
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Sipariş #$shortId',
                                style: TextStyle(
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w700,
                                  color: colors.textPrimary,
                                  fontFamily: AppConstants.fontFamily,
                                ),
                              ),
                              if (order.userName != null &&
                                  order.userName!.isNotEmpty) ...[
                                SizedBox(height: 4.h),
                                Text(
                                  order.userName!,
                                  style: TextStyle(
                                    fontSize: 13.sp,
                                    color: colors.textHint,
                                    fontFamily: AppConstants.fontFamily,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10.w, vertical: 4.h),
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
                    if (order.items.isNotEmpty) ...[
                      SizedBox(height: 4.h),
                      Text(
                        order.items
                            .map((e) => '${e.name} x${e.quantity}')
                            .join(', '),
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
                      children: List.generate(
                        statuses.length,
                        (i) {
                          final isFilled = i <= order.step;
                          return Expanded(
                            child: Container(
                              height: 4.h,
                              margin: EdgeInsets.only(
                                  right: i < statuses.length - 1 ? 2.w : 0),
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
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(
                          _expanded
                              ? Icons.keyboard_arrow_up_rounded
                              : Icons.keyboard_arrow_down_rounded,
                          size: 24.sp,
                          color: colors.textHint,
                        ),
                      ],
                    ),
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
                      SizedBox(height: 16.h),
                      Text(
                        'Toplam: ${order.total} TL',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700,
                          color: colors.textPrimary,
                          fontFamily: AppConstants.fontFamily,
                        ),
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        'Durumu güncelle',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: colors.textHint,
                          fontFamily: AppConstants.fontFamily,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Wrap(
                        spacing: 8.w,
                        runSpacing: 8.h,
                        children: List.generate(4, (i) {
                          final isCurrent = order.step == i;
                          return ChoiceChip(
                            label: Text(
                              statuses[i],
                              style: TextStyle(fontSize: 12.sp),
                            ),
                            selected: isCurrent,
                            onSelected: isCurrent
                                ? null
                                : (_) => widget.onStatusChanged(i),
                            selectedColor: _statusColor(i).withValues(alpha: 0.3),
                            labelStyle: TextStyle(
                              color: isCurrent
                                  ? _statusColor(i)
                                  : colors.textPrimary,
                              fontFamily: AppConstants.fontFamily,
                            ),
                            side: BorderSide(
                              color: isCurrent
                                  ? _statusColor(i)
                                  : colors.surfaceBorder,
                            ),
                          );
                        }),
                      ),
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
